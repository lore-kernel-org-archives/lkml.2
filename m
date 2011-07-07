Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1GGP3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:29:11 -0400
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2984 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1GGP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:29:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv3 03/17] [media] DocBook: Use the generic error code page also for MC API
Date: Thu, 7 Jul 2011 17:29:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1309974026.git.mchehab@redhat.com> <20110706150352.436f7a2a@pedra>
In-Reply-To: <20110706150352.436f7a2a@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071729.03676.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 06, 2011 20:03:52 Mauro Carvalho Chehab wrote:
> Instead of having their own generic error codes at the MC API, move
> its section to the generic one and be sure that all media ioctl's
> will point to it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/gen-errors.xml b/Documentation/DocBook/media/v4l/gen-errors.xml
> index 6ef476a..a7f73c9 100644
> --- a/Documentation/DocBook/media/v4l/gen-errors.xml
> +++ b/Documentation/DocBook/media/v4l/gen-errors.xml
> @@ -5,6 +5,11 @@
>    <tgroup cols="2">
>      &cs-str;
>      <tbody valign="top">
> +	<!-- Keep it ordered alphabetically -->
> +      <row>
> +	<entry>EBADF</entry>
> +	<entry><parameter>fd</parameter> is not a valid open file descriptor.</entry>
> +      </row>
>        <row>
>  	<entry>EBUSY</entry>
>  	<entry>The ioctl can't be handled because the device is busy. This is
> @@ -15,7 +20,16 @@
>  	       problem first (typically: stop the stream before retrying).</entry>
>        </row>
>        <row>
> +	<entry>EFAULT</entry>
> +	<entry><parameter>fd</parameter> is not a valid open file descriptor.</entry>

This seems to be a copy-and-paste error. The original text in media-func-ioctl.xml says this:

	  <para><parameter>argp</parameter> references an inaccessible memory
	  area.</para>

> +      </row>
> +      <row>
>  	<entry>EINVAL</entry>
> +	<entry>One or more of the ioctl parameters are invalid. This is a widely

widely -> widely used

> +	       error code. see the individual ioctl requests for actual causes.</entry>

see -> See

Regards,

	Hans

> +      </row>
> +      <row>
> +	<entry>EINVAL or ENOTTY</entry>
>  	<entry>The ioctl is not supported by the driver, actually meaning that
>  	       the required functionality is not available.</entry>
>        </row>
> @@ -25,7 +39,7 @@
>        </row>
>        <row>
>  	<entry>ENOSPC</entry>
> -	<entry>On USB devices, the stream ioctl's can return this error meaning
> +	<entry>On USB devices, the stream ioctl's can return this error, meaning
>  	       that this request would overcommit the usb bandwidth reserved
>  	       for periodic transfers (up to 80% of the USB bandwidth).</entry>
>        </row>
> diff --git a/Documentation/DocBook/media/v4l/media-func-ioctl.xml b/Documentation/DocBook/media/v4l/media-func-ioctl.xml
> index bda8604..e0ee285 100644
> --- a/Documentation/DocBook/media/v4l/media-func-ioctl.xml
> +++ b/Documentation/DocBook/media/v4l/media-func-ioctl.xml
> @@ -63,54 +63,10 @@
>    </refsect1>
>  
>    <refsect1>
> -    <title>Return Value</title>
> -
> -    <para><function>ioctl()</function> returns <returnvalue>0</returnvalue> on
> -    success. On failure, <returnvalue>-1</returnvalue> is returned, and the
> -    <varname>errno</varname> variable is set appropriately. Generic error codes
> -    are listed below, and request-specific error codes are listed in the
> +    &return-value;
> +    <para>Request-specific error codes are listed in the
>      individual requests descriptions.</para>
>      <para>When an ioctl that takes an output or read/write parameter fails,
>      the parameter remains unmodified.</para>
> -
> -    <variablelist>
> -      <varlistentry>
> -	<term><errorcode>EBADF</errorcode></term>
> -	<listitem>
> -	  <para><parameter>fd</parameter> is not a valid open file descriptor.
> -	  </para>
> -	</listitem>
> -      </varlistentry>
> -      <varlistentry>
> -	<term><errorcode>EFAULT</errorcode></term>
> -	<listitem>
> -	  <para><parameter>argp</parameter> references an inaccessible memory
> -	  area.</para>
> -	</listitem>
> -      </varlistentry>
> -      <varlistentry>
> -	<term><errorcode>EINVAL</errorcode></term>
> -	<listitem>
> -	  <para>The <parameter>request</parameter> or the data pointed to by
> -	  <parameter>argp</parameter> is not valid. This is a very common error
> -	  code, see the individual ioctl requests listed in
> -	  <xref linkend="media-user-func" /> for actual causes.</para>
> -	</listitem>
> -      </varlistentry>
> -      <varlistentry>
> -	<term><errorcode>ENOMEM</errorcode></term>
> -	<listitem>
> -	  <para>Insufficient kernel memory was available to complete the
> -	  request.</para>
> -	</listitem>
> -      </varlistentry>
> -      <varlistentry>
> -	<term><errorcode>ENOTTY</errorcode></term>
> -	<listitem>
> -	  <para><parameter>fd</parameter> is  not  associated  with  a character
> -	  special device.</para>
> -	</listitem>
> -      </varlistentry>
> -    </variablelist>
>    </refsect1>
>  </refentry>
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
> index 1f32373..2ce5214 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
> @@ -127,7 +127,6 @@
>    </refsect1>
>  
>    <refsect1>
> -    <title>Return value</title>
> -    <para>This function doesn't return specific error codes.</para>
> +    &return-value;
>    </refsect1>
>  </refentry>
> 
