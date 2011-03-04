Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab1CDOuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:50:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50782 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562Ab1CDOuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:50:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tQz823Dlv6oaJsmGfw1EBKDPdZCnRs5N1uZKv63qK26Sjd7hQbzaRO0OqIb8B1oZFZ
         Lq08Bg3lU78o2e6y9w1t1BFLS52dXYqrg6oZoPSjSnu+OkPH84v5GvHpotRdaCyu1iYT
         LxxEDQKs43Nre+ni3fTYbj94jlrTAobhyNVKs=
MIME-Version: 1.0
Date: Fri, 4 Mar 2011 15:50:19 +0100
Message-ID: <AANLkTi=-ZZTAb_6cec-GKDBmsjgchM3h9Zg9_39+AD1t@mail.gmail.com>
Subject: 2.6.38-rc6: general protection error inside KVM 64 bits guest
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running kernel 2.6.38-rc6 with qemu-kvm 0.12.3.

Doing this inside the guest:

int main(void)
{
	if (ioperm(0x3e0, 4, 1) < 0) {
		perror("ioperm");
		exit(1);
	}

	outb(0, 0x3e0);
	inb(0x3e1);
	printf("exiting succesfully\n");
	return 0;
}

make a general protection error.

Looking for the faulty instruction with gdb and found that's the 'inb'
instruction the culprit.

Running the same program on the host works fine.

Could anybody tell me what's wrong ?

Thanks
-- 
Francis
