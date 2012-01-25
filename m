Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab2AYLXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:23:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49777 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438Ab2AYLXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:23:00 -0500
Date: Wed, 25 Jan 2012 11:22:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, lrg@ti.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH] regulator: Set apply_uV only when min and max voltages
 are defined
Message-ID: <20120125112257.GA2991@opensource.wolfsonmicro.com>
References: <1327483905-27007-1-git-send-email-k.lewandowsk@samsung.com>
 <4F1FD630.8070606@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1FD630.8070606@samsung.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:15:12AM +0100, Karol Lewandowski wrote:
> On 25.01.2012 10:31, Karol Lewandowski wrote:

> >apply_uV is errornously set when regulator is instantiated from device
> >tree, even when it doesn't contain any voltage constraints.

> While this fixes obvious error I doubt that apply_uV should be set
> based on min max equality. It have required fix to fixed
> regulator[1]

No, I think this is fine.  The only reason the fixed voltage regulator
required anything was that it overloads the constraint voltage values to
specify the voltage which we probably shouldn't have done in the first
place.  If the device is can't change voltages specifying a voltage
range for changes is silly.

> as well for max8997[2].  It'll probably require fixes in other places too.

The big problem there seems like specifying voltages in the first place,
if we know what device it is we should already know what's going on.
