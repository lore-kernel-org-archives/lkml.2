Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab0J0MnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:43:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:65066 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0J0MnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:43:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,246,1286175600"; 
   d="scan'208";a="567836360"
Date: Wed, 27 Oct 2010 12:48:16 +0100
From: Alan Cox <alan@linux.intel.com>
To: samu.p.onkalo@nokia.com
Cc: gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs and power management
Message-ID: <20101027124816.7087436a@linux.intel.com>
In-Reply-To: <1288177143.12206.22.camel@4fid08082>
References: <1288177143.12206.22.camel@4fid08082>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I started to wonder if it makes sense to enhance sysfs so that it
> optionally prodives open / close call backs. Internally sysfs has
> some bookkeeping about the refcount but this is not visible to the
> driver. Of course majority of the sysfs users doesn't need that at all
> and for them this is just overhead. 

I think we need it. There doesn't need to be much overhead however as
there is no need (or sense) in providing per sysfs node open/close
hooks.

The pm layer also lacks a clean race-free way to actually ascertain
when the device was last kicked out of pm saving.
