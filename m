Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1IFQwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:52:02 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59855 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1IFQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:51:55 -0400
Date: Wed, 7 Sep 2011 01:51:44 +0900
From: Tejun Heo <tj@kernel.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, kernel-hardening@lists.openwall.com,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110906165144.GJ18425@mtj.dyndns.org>
References: <20110831140416.GA17626@shutemov.name>
 <20110831142622.GB30615@sun>
 <20110831151023.5b7e12da.akpm@linux-foundation.org>
 <20110901080508.GF30615@sun>
 <20110902163711.GA3124@albatros>
 <20110905185358.GA2103@albatros>
 <20110905192009.GJ761@sun>
 <20110905194908.GA2690@albatros>
 <20110905203627.GL761@sun>
 <20110906101518.GA4799@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906101518.GA4799@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vasiliy.

On Tue, Sep 06, 2011 at 02:15:18PM +0400, Vasiliy Kulikov wrote:
>   c) If dentry is lazily dropped on each access attempt (or each illegal
>      access) then PID2 can:
> 
>      i) read dentry line of /proc/slabinfo
>      ii) call link(2) against /proc/PID/fd, which invalidates the
>          specific dentry
>      iii) re-read dentry line of /proc/slabinfo.  If it has decreased by
>          one, the dentry existed before (ii).

If we really worry about this, probably the right thing to do is
hiding slabinfo from mortal UIDs instead of worrying about what
exactly are freed or not from each user.

Thanks.

-- 
tejun
