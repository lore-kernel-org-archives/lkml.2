Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab2BOO7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:59:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33303 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2BOO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:59:00 -0500
Date: Wed, 15 Feb 2012 14:58:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
Message-ID: <20120215145857.GA21755@srcf.ucam.org>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1202151537500.2794@ionos>
 <1329317650.2293.129.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329317650.2293.129.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of whether userspace should be concerning itself about this 
kind of thing or not, there's plenty of userspace that calls sleep(0) on 
the assumption that it'll get rescheduled. This makes using whole-system 
timer slack difficult, because there are some applications that do this 
even if they're event-driven and sleeping for significant lengths of 
time here breaks them. I'd certainly understand the argument for fixing 
userspace instead, but that's a massive task for something that's easily 
special-cased in the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
