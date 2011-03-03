Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab1CCObA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:31:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61540 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab1CCOa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:30:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=ILa2MD2PptZXpoVnmEgVBcf50AtLr/XEt7EjtPlCfkPH/y7mYxFfXMrWs/Ysm00YnR
         N+HTiqs6iNvphQG3R5cCpHmWBt71Wmsnf1cstdZvxelriRnU70CEYKn+qU4YmPr6/rci
         Rl/DVsVJBgjk11Y0+AnnORXVXV8huyMUd9u6Y=
Date: Fri, 4 Mar 2011 01:00:51 +1030
From: Alan Modra <amodra@gmail.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Hui Zhu <teawater@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, binutils@sourceware.org
Subject: Re: [BUG] as of trunk build Linux kernel trunk entry_32.S got error
Message-ID: <20110303143051.GI13094@bubble.grove.modra.org>
Mail-Followup-To: "H.J. Lu" <hjl.tools@gmail.com>,
	Hui Zhu <teawater@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, binutils@sourceware.org
References: <AANLkTimqT82wR20vvunnMvNShFSs0zWtmeT66A84Nh5t@mail.gmail.com>
 <AANLkTi=m_qO0=o81+Db_B-kt1DWP-Af6So+_LiZMgONF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=m_qO0=o81+Db_B-kt1DWP-Af6So+_LiZMgONF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 05:48:01AM -0800, H.J. Lu wrote:
> On Wed, Mar 2, 2011 at 10:16 PM, Hui Zhu <teawater@gmail.com> wrote:
> > as -version
> > GNU assembler (GNU Binutils) 2.21.51.20110303
> >  AS      arch/x86/kernel/entry_32.o
> > /home/teawater/big/kernel/linux-2.6/arch/x86/kernel/entry_32.S:
> > Assembler messages:
> > /home/teawater/big/kernel/linux-2.6/arch/x86/kernel/entry_32.S:1422:
> > Error: .size expression does not evaluate to a constant
> >
> > When I change back to the as of system, everything is OK.
> >
> > Because I always use the as of trunk, so I think a recent PATCH caused
> > the problem.
> >
> 
> You need
> 
> http://git.kernel.org/?p=linux/kernel/git/hjl/linux-2.6.37.y.git;a=commitdiff;h=2c5ce9c1b8eb927c131a31d4466e24e00647e9cb

That doesn't fix the similar entry_32.S problem.  Here you go.

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..9ca3b0e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1413,7 +1413,7 @@ ENTRY(async_page_fault)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
-END(apf_page_fault)
+END(async_page_fault)
 #endif
 
 /*

-- 
Alan Modra
Australia Development Lab, IBM
