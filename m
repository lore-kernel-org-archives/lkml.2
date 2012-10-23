Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2JWAEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:04:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JWAEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:04:54 -0400
Date: Mon, 22 Oct 2012 17:04:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Wollrath <julian.wollrath@stud.uni-goettingen.de>
Cc: Julian Wollrath <jwollrath@web.de>,
        Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
Subject: Re: Major performance regressions in 3.7rc1/2
Message-Id: <20121022170452.cc8cc629.akpm@linux-foundation.org>
In-Reply-To: <20121022214502.0fde3adc@ilfaris>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
	<20121022173315.7b0da762@ilfaris>
	<20121022214502.0fde3adc@ilfaris>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 21:45:02 +0200
Julian Wollrath <julian.wollrath@stud.uni-goettingen.de> wrote:

> Hello,
> 
> seems like I found the other bad commit. Everything, which means
> v3.7-rc*, works fine again with commit e6c509f85 (mm: use
> clear_page_mlock() in page_remove_rmap()) and commit 957f822a0 (mm,
> numa: reclaim from all nodes within reclaim distance) revoked.

Thanks.  Let's add some cc's.  Can you please describe your workload
and some estimate of the slowdown?

Patrik has also seen this and his description is

: I'm using an Asus Zenbook UX31E and have been installing all RCs in
: hope of improving the Wireless and Touchpad functionality.
: However, when trying 3.7 (rc1 and now rc2) I have major performance issues.
: 
: Easiest way to reproduce is to launch and play a game like Nexuiz,
: where the computer will lag, stutter and freeze until the machine is
: unresponsive within a couple of minutes.
: But an easy workload like browsing will also cause lags when switching
: tabs or redrawing a web page after a tab switch.
: Basically 3.7 is unusable for this machine.

