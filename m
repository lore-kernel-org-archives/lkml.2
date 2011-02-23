Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1BWN6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:58:06 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:39360
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932253Ab1BWN6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:58:01 -0500
Date: Wed, 23 Feb 2011 13:58:14 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
Subject: Re: User namespaces and keys
Message-ID: <20110223135814.GA1859@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
 <29677.1298462729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29677.1298462729@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> 
> I guess we need to look at how to mix keys and namespaces again.

>From strictly kernel pov, at the moment, keys are strictly usable only
by the user in your own user namespace.

We may want to look at this again, but for now I think that would be a
safe enough default.  Later, we'll probably want the user creating a
child_user_ns to allow his keys to be inherited by the child user_ns.
Though, as I type that, it seems to me that that'll just become a
maintenance pain, and it's just plain safer to have the user re-enter
his keys, sharing them over a file if needed.

I'm going to not consider the TPM at the moment :)

> Possibly the trickiest problem with keys is how to upcall key construction to
> /sbin/request-key when the keys may be of a different user namespace.

Hm, jinkeys, yes.

-serge
