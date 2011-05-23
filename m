Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1EWGAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:00:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59844 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1EWF77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=F6jJ0wjBW0Hi2o1ajnFW5eZQpKjUJYefg0Br3i7UNHjTd8MTUShr0qtXaRMewyZgOy
         zPBZyzLr3i/pJWoYcHQKVHOrBpChomTuNGF/njFT6Vcb/qdMHs/1iZvCQDeN+YrbgLiF
         5tuWjHGsn+3gik/D6gv4qUuVE33Z98Fb3NrxI=
MIME-Version: 1.0
In-Reply-To: <m14o4mavod.fsf@fess.ebiederm.org>
References: <BANLkTim7xn8tM4wTyd_m_nwUQg_CUTapeA@mail.gmail.com> <m14o4mavod.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 23 May 2011 08:59:39 +0300
Message-ID: <BANLkTik0NZSC84-_-j0LyyzSJykH-VxGXw@mail.gmail.com>
Subject: Re: [v3 00/39] faster tree-based sysctl implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 7:27 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> I will mention a couple of nits I noticed while I was skimming through
> your patches.
> - There can be multiple proc superblocks and thus multiple inodes
>  referring to the same /proc/sys file, if there are multiple pid
>  namespaces.


OK. I'll revert the patch that make converts an int counter into an u8
and post an update. I guess this is what you were referring to.
https://github.com/luciang/linux-2.6-new-sysctl/commit/b7a547b8ce7484ae22eea34a860f674fcb19c11b


> - I have a hope to move /proc/sys into /proc/<pid>/sys so we don't have
>  to look at current to determine the namespace we want to display.
>  That would allow the deeply magic sysctl_is_seen check to be removed
>  from proc_sys_compare.  That is not your problem, but of an
>  explanation why the namespaces are passed through.


OK, I'll go an change things to pass the current namespace as it were
before my changes.


Thank you.
-- 
 .
..: Lucian
