Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0EYN1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:27:13 -0400
Received: from mga05.intel.com ([192.55.52.89]:1770 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756519Ab0EYN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:27:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,298,1272870000"; 
   d="scan'208";a="801680307"
Date: Tue, 25 May 2010 13:42:58 +0100
From: Alan Cox <alan@linux.intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] TTY/n_gsm: potential double lock
Message-ID: <20100525134258.568a600f@linux.intel.com>
In-Reply-To: <20100525093717.GC22515@bicker>
References: <20100525093717.GC22515@bicker>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 11:37:17 +0200
Dan Carpenter <error27@gmail.com> wrote:

> In gsm_dlci_data_kick() we call gsm_dlci_data_sweep() with the
> "gsm->tx_lock" held so we can't lock it again inside
> gsm_dlci_data_sweep().  I removed that lock from and added one to 
> gsmld_write_wakeup() instead.  The sweep function is only called from
> those two places.

Well spotted - I'm surprised that escaped as I've been using the code a
fair bit in that exact form. Not immediately obvious that the case
should be that hard to trigger.

> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>

