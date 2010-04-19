Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0DSRrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:47:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58462 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0DSRrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:47:46 -0400
Date: Mon, 19 Apr 2010 18:47:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH] use acpi_idle_enter_simple if bm_check &&
	!.bm_control
Message-ID: <20100419174737.GA13331@srcf.ucam.org>
References: <3877989d0911092212i367b9156n78d57aeee6742147@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0911092212i367b9156n78d57aeee6742147@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 02:12:41PM +0800, Luming Yu wrote:

> I came across acpi processor idle driver, noticed that we can cut a
> bit overhead at C3 entry that can improve C3 residency a bit,
> especially when it has similar kernel config as old RHEL 5 kernel
> (2.6.18) on systems with as many as 64 logical CPUs. The point of this
> patch is bm_sts is an optional bit. It never returns 1 on systems with
> bm_check && !bm_control I tested. Instead, I have observed lower C3
> residency due to accessing bm_sts and relevant code on a system with
> 64 logical CPUs with HZ=1000. Please review. If make sense, please
> apply.

Saves 40W or so on a dual-socket Nehalem system here. Is there a reason 
it wasn't picked up?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
