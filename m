Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1KHAOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:14:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59286 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab1KHAOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:14:03 -0500
Date: Tue, 8 Nov 2011 00:14:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        marco.stornelli@gmail.com, seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops: Add a device file for ramoops buffer access.
Message-ID: <20111108001402.3d1a8fb4@lxorguk.ukuu.org.uk>
In-Reply-To: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
References: <1320710760-2734-1-git-send-email-bfreed@chromium.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static int ramoops_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = &oops_cxt;

Well I guess you'll only have one..

> +	if (copy_to_user(buf, from, count))
> +		count = -EFAULT;
> +	else
> +		*ppos += count;

Mindnumbingly pedantically you should return -EFAULT only if none of the
bytes copied, otherwise the partial length. Do we actually care in a case
like this - not really.

Looks good to me and we really want to get away from using /dev/mem for
stuff. Ideally to a world where /dev/mem can be compiled out of any
normal system completely so

Acked-by: Alan Cox <alan@linux.intel.com>
