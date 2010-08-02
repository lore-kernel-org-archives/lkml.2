Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab0HBLxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:53:51 -0400
Received: from web100105.mail.kks.yahoo.co.jp ([114.111.99.80]:48440 "HELO
	web100105.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751452Ab0HBLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:53:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Subject:To:MIME-Version:Content-Type;
  b=sY4Es76h2q/EDco0/y8Dzg+aleyUxUp2fSCuHbylUnEAZff6UtOjrMwsGR1n87HOz3lDvdpvDIu0COtthoEi/JGkmPamo96kR5SGsyepTDclJRX7/NsagoPTa6eD9RMk  ;
Message-ID: <20100802115325.94834.qmail@web100105.mail.kks.yahoo.co.jp>
Date: Mon, 2 Aug 2010 20:53:25 +0900 (JST)
From: tanaka <tanaka_hideo@yahoo.co.jp>
Subject: when does  a program become processed ?  static void unknown_nmi_error
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.good evening.

what in case is program executed ?
Does program jump here with vector procedure ?

regards.

http://code.ossmpedia.org/linux/source/arch/i386/kernel/traps.c?a=x86_64#646

646 static void unknown_nmi_error(unsigned char reason, struct pt_regs *
regs)
647 {
648 #ifdef CONFIG_MCA
649         /* Might actually be able to figure out what the guilty party
650         * is. */
651         if( MCA_bus ) {
652                 mca_handle_nmi();
653                 return;
654         }
655 #endif
656         printk("Uhhuh. NMI received for unknown reason %02x on CPU
%d.\n",
657                 reason, smp_processor_id());
658         printk("Dazed and confused, but trying to continue\n");
659         printk("Do you have a strange power saving mode enabled?\n");
660 }

--------------------------------------
Are you OK?  Online Safety Special Site - Yahoo! JAPAN
http://pr.mail.yahoo.co.jp/security/
