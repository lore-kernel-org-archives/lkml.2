Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1IMRaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:30:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47062 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab1IMRaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:30:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6467"; a="118257094"
Date: Tue, 13 Sep 2011 10:30:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Alexander Tarasikov <alexander.tarasikov@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Question] RPC and SMD implementation
Message-ID: <20110913173010.GA4222@huya.qualcomm.com>
References: <CAMChaFwHt62vLeRoVCpya5yt5xctPSnwPuEGrA0rK45yxwtoGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMChaFwHt62vLeRoVCpya5yt5xctPSnwPuEGrA0rK45yxwtoGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 05:29:55PM +0400, Alexander Tarasikov wrote:

> Since RPC and SMD drivers are not fully integrated to vanilla linux,
> I'd like to discuss a few points about them so that we don't face
> troubles when these drivers are submitted.
> 
> As you know, most AMSS versions for modern QSD/MSM chips have the same
> magic numbers for RPC program/version/procedure calls. Older ones
> (namely, msm72[02]x), on the contrary, all have different versions. It
> has been solved in hackish ways in Android kernel trees. Google's tree
> had the AMSS version selectable in the config and code for different
> AMSS was put under ifdefs. It is needless to say that this is a very
> bad practice. No only the code size grows with any new version added,
> but also we cannot support multiple devices or even multiple firmwares
> on the same device in one kernel binary. Besides, if someone makes a
> change to one branch of an ifdef, chances are they break the
> compilation of another branch unless they're testing all possible
> combinations. The kernel at CodeAurora git defines some kind of
> functions that check if the RPC version on the BP is compatible with
> the one in AP linux kernel, but it also needs to do like 3 or 4 probes
> to get version which makes code unreadable.

Is there much reason to get the msm72xx support into the kernel in the
first place?  These targets are old, and I don't believe any new
devices are being made using them.  There are no dev boards based on
this chipset.  Things are a lot easier in the newer RPC/SMD versions,
and I don't see a strong reason to keep the kruft in the kernel
necessary to support the 72xx chips.

> I also propose that we pass the following platform data structure to
> the SMD driver
> struct msm_smd_platform_data {
>                 struct amss_value *amss_values; //can be just an array
> as mentioned above
>                 int n_amss_values;
>                 struct msm_early_server *early_servers;
>                 int n_early_servers;
> }
> where struct msm_early_server is { uint32_t cid; uint32_t pid;
> uint32_t prog; uint32_t vers; }. Some legacy AMSS versions (namely,
> 5225 and 6150) need to manually register some servers for the ADSP.

We're not going to be able to get any new platform data.  If this is
really needed, it'll have to be represented in the device tree and
looked up that way.

> What I want is to be able to integrate both official Android phones
> and community ports into vanilla and to be able to build the support
> for as many devices as possible in a single binary and set everything
> up in runtime. Please let me know what the current plans on
> integrating RPC and SMD (tty driver) are and whether you need help
> with implementing the proposed changes.

My desire is to focus on newer chips (msm8660 and beyond) in the
mainstream kernel.  At some point, there will be enough cruft from the
older targets (especially 7200) that it isn't worth carrying the
support along, especially as there are fewer and fewer of these
devices around.

The msm8660 is the first MSM chipset with a readily-available
development platform.  I'd like to start by getting this to work well.

You've probably noticed that Google drops old targets in their newer
kernel versions.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
