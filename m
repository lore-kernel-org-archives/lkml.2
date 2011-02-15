Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1BOAWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:22:15 -0500
Received: from smtp-out.google.com ([74.125.121.67]:15881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1BOAWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GQ+N2s9Y9mhgAQIuqeotAChIBXmBo9+b26iVxlMXlznJbcCL8ruSNxPsUyQc1Fzyne
         /0qAnbw/NVeixEsmSMYg==
MIME-Version: 1.0
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BD96CFB1@HQMAIL03.nvidia.com>
References: <1297726034-32762-1-git-send-email-achew@nvidia.com>
	<AANLkTinvpo=R1pjvykEZVXV08D+uXLJa=R8CDcMFWWpT@mail.gmail.com>
	<643E69AA4436674C8F39DCC2C05F763816BD96CFB1@HQMAIL03.nvidia.com>
Date: Mon, 14 Feb 2011 16:22:11 -0800
X-Google-Sender-Auth: u1YFe7Fvz3zkO10zonesyD8VxA0
Message-ID: <AANLkTin+uxnM-u7N-+aXUzGVm7m2eXZKrenDbRPq1V-W@mail.gmail.com>
Subject: Re: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
From: Erik Gilling <konkers@android.com>
To: Andrew Chew <AChew@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, including the relative path was a bit of a hack since the nvhost
drivers needs some serious work before it's upstreamable.  A "right"
way to do this is to have the syncpt functions take an nvhost_device
pointer (or create helper functions that do that,) then expose those
functions in mach/nvhost.h.  This obviates the need for a global
nvhost_sycpt pointer.

-Erik

On Mon, Feb 14, 2011 at 4:08 PM, Andrew Chew <AChew@nvidia.com> wrote:
>> If you want to use syncpts you should be an nvhost_driver link the dc.
>
> Looking at drivers/video/tegra/dc, I notice that it gets access to the syncpt functions by using a relative path (../host/dev.h) to include dev.h, which in turn includes nvhost_syncpt.h (in drivers/video/tegra/host).  Is this proper form?
>
> This syncpt access is for a Tegra V4L2 driver, which will live in drivers/media/video.  I was trying to avoid using relative paths for #includes.  I assumed that the header files in drivers/video/tegra/host were not meant to be publicly available to other drivers, which is why I looked for some precedent in how nvhost functions were made available to other kernel drivers, hence I modeled this after nvmap.
