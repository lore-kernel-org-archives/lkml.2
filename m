Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0JRXHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:07:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0JRXHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=Y6dAHvm9sQVLdLW6zTFhQvcUc7s1t7qFJ+xaTA/t+qIy9SHmPtsZ7XvnBgFuWoSyKX
         KKcJwNZJDcZ7GJSv3LyvcREG5Wlr9qEMq5clwHIFX2F6OM2Zff0b0pmFwe79h64/51CK
         Bj+qFykdT0vhR62LUSsbIyoswNKVRTbY8kqfQ=
MIME-Version: 1.0
In-Reply-To: <20101018103729.GA4122@linux.vnet.ibm.com>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com> <20101018103729.GA4122@linux.vnet.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 18 Oct 2010 19:07:13 -0400
Message-ID: <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
Subject: Re: [PATCH 2/2] initramfs: Fix initramfs size calculation
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Mike Frysinger <vapier.adi@gmail.com>, mmarek@suse.cz,
        Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 06:37, Hendrik Brueckner wrote:
> On Sun, Oct 17, 2010 at 02:28:11PM -0400, Mike Frysinger wrote:
>> On Tue, Aug 31, 2010 at 04:23, Hendrik Brueckner wrote:
>> i'm pretty sure this breaks on every symbol-prefixed arch.  at least,
>> it broke every Blackfin board:
>> init/built-in.o: In function `populate_rootfs':
>> init/initramfs.c:(.init.text+0x2548): undefined reference to `__initramfs_size'
>> init/initramfs.c:(.init.text+0x254e): undefined reference to `__initramfs_size'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> look at VMLINUX_SYMBOL() in the vmlinux.lds.h file
>
> Thanks for your feedback.  Could you try the patch below and let me know
> if it works for your Blackfin board.

negative.  same error.  vmlinux.lds.h might need to be switched to
CONFIG_SYMBOL_PREFIX.
-mike
