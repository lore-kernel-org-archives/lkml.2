Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2IZXlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:41:40 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:50786 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2IZXli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:41:38 -0400
Date: Thu, 27 Sep 2012 01:41:31 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, hdk@igel.co.jp
Subject: Re: [v2 PATCH 2/2] Add uio_dmem_genirq description to UIO
 documentation
Message-ID: <20120926234131.GC4776@local>
References: <1348553352-14334-1-git-send-email-dhobsong@igel.co.jp>
 <1348553352-14334-3-git-send-email-dhobsong@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348553352-14334-3-git-send-email-dhobsong@igel.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 03:09:12PM +0900, Damian Hobson-Garcia wrote:
> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>

Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

> ---
>  Documentation/DocBook/uio-howto.tmpl |   56 ++++++++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index ac3d001..db08c1a 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -719,6 +719,62 @@ framework to set up sysfs files for this region. Simply leave it alone.
>  	</para>
>  </sect1>
>  
> +<sect1 id="using uio_dmem_genirq">
> +<title>Using uio_dmem_genirq for platform devices</title>
> +	<para>
> +	In addition to statically allocated memory ranges, they may also be
> +	a desire to use dynamically allocated regions in a user space driver.
> +	In particular, being able to access memory made available through the
> +	dma-mapping API, may be particularly useful.  The
> +	<varname>uio_dmem_genirq</varname> driver provides a way to accomplish
> +	this.
> +	</para>
> +	<para>
> +	This driver is used in a similar manner to the
> +	<varname>"uio_pdrv_genirq"</varname> driver with respect to interrupt
> +	configuration and handling.
> +	</para>
> +	<para>
> +	Set the <varname>.name</varname> element of
> +	<varname>struct platform_device</varname> to
> +	<varname>"uio_dmem_genirq"</varname> to use this driver.
> +	</para>
> +	<para>
> +	When using this driver, fill in the <varname>.platform_data</varname>
> +	element of <varname>struct platform_device</varname>, which is of type
> +	<varname>struct uio_dmem_genirq_pdata</varname> and which contains the
> +	following elements:
> +	</para>
> +	<itemizedlist>
> +	<listitem><varname>struct uio_info uioinfo</varname>: The same
> +	structure used as the  <varname>uio_pdrv_genirq</varname> platform
> +	data</listitem>
> +	<listitem><varname>unsigned int *dynamic_region_sizes</varname>:
> +	Pointer to list of sizes of dynamic memory regions to be mapped into
> +	user space.
> +	</listitem>
> +	<listitem><varname>unsigned int num_dynamic_regions</varname>:
> +	Number of elements in <varname>dynamic_region_sizes</varname> array.
> +	</listitem>
> +	</itemizedlist>
> +	<para>
> +	The dynamic regions defined in the platform data will be appended to
> +	the <varname> mem[] </varname> array after the platform device
> +	resources, which implies that the total number of static and dynamic
> +	memory regions cannot exceed <varname>MAX_UIO_MAPS</varname>.
> +	</para>
> +	<para>
> +	The dynamic memory regions will be allocated when the UIO device file,
> +	<varname>/dev/uioX</varname> is opened.
> +	Simiar to static memory resources, the memory region information for
> +	dynamic regions is then visible via sysfs at
> +	<varname>/sys/class/uio/uioX/maps/mapY/*</varname>.
> +	The dynmaic memory regions will be freed when the UIO device file is
> +	closed. When no processes are holding the device file open, the address
> +	returned to userspace is DMA_ERROR_CODE.
> +	</para>
> +</sect1>
> +
>  </chapter>
>  
>  <chapter id="userspace_driver" xreflabel="Writing a driver in user space">
> -- 
> 1.7.5.4
> 
> 
