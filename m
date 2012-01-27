Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2A0SZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:25:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab2A0SZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:25:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAP145pggJUr9NnHNPMF2_i58+axbLT+YYaoetQ13Gwt7cnrvOQ@mail.gmail.com>
References: <CAP145pggJUr9NnHNPMF2_i58+axbLT+YYaoetQ13Gwt7cnrvOQ@mail.gmail.com> <20120126012626.09ca152f.akpm@linux-foundation.org> <20120126162820.GA7083@sergelap>
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: dhowells@redhat.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Badness around put_cred()
Date: Fri, 27 Jan 2012 18:25:08 +0000
Message-ID: <6752.1327688708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One thing you could try doing is making do_notify_resume() check the credential
subscriptions on the process as it's about to resume userspace.  The following
assertions both ought to hold:

	BUG_ON(current->cred != current->real_cred);
	BUG_ON(atomic_read(current->cred->usage) >= 2);

And then set TIF_NOTIFY_RESUME in put_cred() and get_new_cred().

David
