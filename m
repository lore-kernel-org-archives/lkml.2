Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1KZUEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:04:40 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48478 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab1KZUEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:04:35 -0500
X-Sasl-enc: sNc2R54uJ5KQb4aFDhkgO7qqzZn+cXxCJCGwBZe+r7Vx 1322337874
Date: Sat, 26 Nov 2011 12:03:41 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 3/7] drivers/zio: core files for the ZIO input/output
Message-ID: <20111126200341.GD11421@kroah.com>
References: <cover.1322328073.git.rubini@gnudd.com>
 <51ba376321edbd0bcbd206cb28abb14a68a05a2b.1322328075.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ba376321edbd0bcbd206cb28abb14a68a05a2b.1322328075.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 06:30:42PM +0100, Alessandro Rubini wrote:
> +static struct kobj_type zdktype = { /* For standard and extended attribute */
> +	.release   = NULL,

Sweet!

As-per the in-kernel documentation, I now get to mock you for doing
this :)

Please NEVER DO THIS, you are ignoring the messages that the kernel
sends you when you remove one of these devices, and causing a memory
leak.

Not nice at all, yet another reason to use a 'struct device'.

thanks,

greg k-h
