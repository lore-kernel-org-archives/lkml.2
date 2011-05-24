Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1EXOBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:01:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:60768 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1EXOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:01:46 -0400
Date: Tue, 24 May 2011 16:01:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Pengfei Zhang <zoppof.zhang@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS:i8259.c remove resume and shutdown to syscore_ops
In-Reply-To: <20110524135940.GA30117@linux-mips.org>
Message-ID: <alpine.LFD.2.02.1105241600180.3078@ionos>
References: <1306239558-4997-1-git-send-email-zoppof.zhang@gmail.com> <20110524135940.GA30117@linux-mips.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Ralf Baechle wrote:

> On Tue, May 24, 2011 at 08:19:18PM +0800, Pengfei Zhang wrote:
> 
> > Remove the resume and shutdown of i8259A from the sysdev_class
> > to the syscore_ops since these members had removed from the
> > structure sysdev_class.
> 
> I don't see why one would want to want to first call register_syscore_ops
> then sysdev_class_register and sysdev_register?

The whole point of syscore_ops is to get rid of the sysdev which had
only one purpose: handing the suspend/resume ops in. The resulting
sysfs entry is completely useless.

Thanks,

	tglx
