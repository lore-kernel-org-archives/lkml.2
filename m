Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0HPNYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:24:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:52477 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab0HPNYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:24:10 -0400
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <87ocddz4zy.fsf@depni.sinp.msu.ru>
Date: Mon, 16 Aug 2010 15:24:08 +0200
Cc: Dieter Ries <mail@dieterries.net>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <122B6102-F892-4D2C-A85B-52F9BB0CB11E@suse.de>
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com> <4BA1504A.3090801@dieterries.net> <808FF008-53B9-4271-904C-117A24ADF18C@suse.de> <20100317224002.GA5156@Localhorst.asterix.local> <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de> <20100318071131.GC24062@Localhorst.asterix.local> <4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de> <87ocddz4zy.fsf@depni.sinp.msu.ru>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08.08.2010, at 14:02, Serge Belyshev wrote:

> Hi! Since the above patch went in
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=10474ae8
> I have exactly the same problem as Dieter.
> 
>>>> If that's the case I'd say you have a broken BIOS or bootloader.
>>> 
>>> You are right, it seems to be always cpu0. I'll check my BIOS and flash
>>> a newer version if available.
>> 
>> Please do. If that doesn't help ping me again. I'll write up a quirk patch then.
>> 
> 
> My h/w is a bit different (cpu: 9850 B3, mb: GA-MA790FX-DQ6 bios F7b),
> but I cannot use latest available BIOS (F7d) as it breaks my SAS controller.
> 
> So I guess I need the quirk patch.

Hrm - try to use the following (probably whitespace broken and 100% untested) hacky patch:

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 56c9b6b..bde9ee3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -429,9 +429,11 @@ static int svm_hardware_enable(void *garbage)
        struct desc_struct *gdt;
        int me = raw_smp_processor_id();
 
+#if 0
        rdmsrl(MSR_EFER, efer);
        if (efer & EFER_SVME)
                return -EBUSY;
+#endif
 
        if (!has_svm()) {
                printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",


Alex