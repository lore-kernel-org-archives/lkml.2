Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0FUPgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:36:10 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:46968 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932797Ab0FUPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:36:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r7m7OobfWKnPdRgRTo/rA0km0dYriG/6Xl+5anHwz135fUs4fet0R6SGvYKJHWAISxMC/C/PodXbTm1lXr0EBGiJz0wzwqUffkQw5tEhdijxJlYlYTRwNDMSwfj3XhxS;
Date: Mon, 21 Jun 2010 08:34:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, mjg@redhat.com,
       platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: intel_ips, check for kzalloc properly
Message-ID: <20100621083418.6315d1d5@virtuousgeek.org>
In-Reply-To: <4C1F865C.1070707@gmail.com>
References: <1277132531-14242-1-git-send-email-jslaby@suse.cz>
	<20100621082535.14301a7c@virtuousgeek.org>
	<4C1F865C.1070707@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 17:33:48 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 06/21/2010 05:25 PM, Jesse Barnes wrote:
> > On Mon, 21 Jun 2010 17:02:11 +0200
> > Jiri Slaby <jslaby@suse.cz> wrote:
> > 
> >> Stanse found that there are two NULL checks missing in ips_monitor. So
> >> check their value too and bail out appropriately if the allocation
> >> failed.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> >> Cc: Matthew Garrett <mjg@redhat.com>
> >> ---
> >>  drivers/platform/x86/intel_ips.c |    3 ++-
> >>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
> >> index cdaf40e..3c7ea9a 100644
> >> --- a/drivers/platform/x86/intel_ips.c
> >> +++ b/drivers/platform/x86/intel_ips.c
> >> @@ -931,7 +931,8 @@ static int ips_monitor(void *data)
> >>  	mch_samples = kzalloc(sizeof(u16) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> >>  	cpu_samples = kzalloc(sizeof(u32) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> >>  	mchp_samples = kzalloc(sizeof(u32) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> >> -	if (!mcp_samples || !ctv1_samples || !ctv2_samples || !mch_samples) {
> >> +	if (!mcp_samples || !ctv1_samples || !ctv2_samples || !mch_samples ||
> >> +			!cpu_samples || !mchp_samples) {
> >>  		dev_err(&ips->dev->dev,
> >>  			"failed to allocate sample array, ips disabled\n");
> >>  		kfree(mcp_samples);
> > 
> > Ah cool, am I also missing the appropriate kfree() calls for the last
> > two?  The context doesn't have it.  Otherwise,
> 
> I checked when I was patching that and the last is not freed there.
> However I didn't add it since at least one must be non-NULL and in this
> case it can be only the last. (Until somebody add another allocation
> indeed.) So should I add even the last free there?

Up to Matthew.  Not adding it will make people do a double take, but I
agree it'll be safe.

-- 
Jesse Barnes, Intel Open Source Technology Center
