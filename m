Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1BOBuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:50:02 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61344 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1BOBt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aD6Z0sUur8K+Uh94w34rOuW876KzI+Ly2ENe9RFd7/x1SkFz0rxZKpycxcCBRDS/gc
         VRGpTfoLmbRmCXDmk4wQ==
MIME-Version: 1.0
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BD96CFB2@HQMAIL03.nvidia.com>
References: <1297726034-32762-1-git-send-email-achew@nvidia.com>
	<AANLkTinvpo=R1pjvykEZVXV08D+uXLJa=R8CDcMFWWpT@mail.gmail.com>
	<643E69AA4436674C8F39DCC2C05F763816BD96CFB1@HQMAIL03.nvidia.com>
	<AANLkTin+uxnM-u7N-+aXUzGVm7m2eXZKrenDbRPq1V-W@mail.gmail.com>
	<643E69AA4436674C8F39DCC2C05F763816BD96CFB2@HQMAIL03.nvidia.com>
Date: Mon, 14 Feb 2011 17:49:54 -0800
X-Google-Sender-Auth: qjKCcS0Ty9g9HMxsVkqPtgfwzsc
Message-ID: <AANLkTi=aMA_OTgtw37jdDrSyMm4jmvpvFt5LpyyoG9PP@mail.gmail.com>
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

On Mon, Feb 14, 2011 at 4:47 PM, Andrew Chew <AChew@nvidia.com> wrote:
>> Yeah, including the relative path was a bit of a hack since the nvhost
>> drivers needs some serious work before it's upstreamable.  A "right"
>> way to do this is to have the syncpt functions take an nvhost_device
>> pointer (or create helper functions that do that,) then expose those
>> functions in mach/nvhost.h.  This obviates the need for a global
>> nvhost_sycpt pointer.
>>
>> -Erik
>
> You're right about that global nvhost_syncpt pointer.  That drives me nuts as well.  Nevertheless, I'm not sure I'm knowledgeable enough to do the required work to do this the "right" way.  As far as I know, nvhost is a guaranteed singleton in practice (not in implementation), so while this is ugly, it will work fine for existing projects.

If you feel uncomfortable making this change, I recommend you include
the private header file the way the dc does.

> Can we use nvmap as precedent and do it this way for now?  I'd like to get the V4L2 camera host driver up to the Tegra community as soon as possible.  When the problem is solved for the dc driver, I can adapt that to the V4L2 camera host driver.

nvmap (another piece of code that needs a lot of work before it's
upstream) is a horrible example to use as a precedent.  This whole
discussion is somewhat moot as you're building your driver against two
pieces that have no clear path to being upstreamed.  You are welcome
to make any changes you want in your own repository for supporing V4L2
but I won't be pulling this syncpt patch into
git://android.git.kernel.org/kernel/tegra.git.

-Erik
