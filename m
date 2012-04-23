Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2DWKTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:19:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29914 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab2DWKTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:19:39 -0400
Message-ID: <4F952CAD.5070405@openvz.org>
Date: Mon, 23 Apr 2012 14:19:25 +0400
From: Kinsbursky Stanislav <skinsbursky@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH v2 0/2] IPC: message queue checkpoint/restore -
 requested updates
References: <20120416140235.653.36996.stgit@localhost6.localdomain6>
In-Reply-To: <20120416140235.653.36996.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.
I'm very sorry, but a critical flaw has been found in this feature: copying of 
kernel data to user is done under spinlock.
Since message queue size can be increased up to INT_MAX, then copying to 
temporary kernel buffer while passing message queue in not a solution.
So, please, drop both patches (feature implementation and test).
Most probably Ill replace them with MSG_PEEK feature (the same logic, but only 
for one message - like it's done for sockets).

-- 
Best regards,
Stanislav Kinsbursky

