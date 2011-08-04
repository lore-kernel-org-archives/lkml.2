Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1HDLnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:43:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47326 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1HDLnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110804103336.GE17540@legolas.emea.dhcp.ti.com>
References: <20110804102950.10845.67898.stgit@ponder> <20110804103336.GE17540@legolas.emea.dhcp.ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 12:42:41 +0100
X-Google-Sender-Auth: lzO3FBXdMAg5GbAgGVp52P0QTQk
Message-ID: <CACxGe6vnspztEnUH5odGnK4x_K9Ej3Nt7BxikVQwOr9Uh_ED7g@mail.gmail.com>
Subject: Re: [PATCH] dt: remove of_alias_get_id() reference
To: balbi@ti.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 11:33 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Aug 04, 2011 at 11:30:27AM +0100, Grant Likely wrote:
>> of_alias_get_id() is broken and being reverted.  Remove the reference
>> to it and replace with a single incrementing id number.
>>
>> There is no risk of regression here on the imx driver since the imx
>> change to use of_alias_get_id() is commit 22698aa2, "serial/imx: add
>> device tree probe support" which is new for v3.1, and it won't get
>> used unless CONFIG_OF is enabled and the board is booted using a
>> device tree.  A single incrementing integer is sufficient for now.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Shawn Guo <shawn.guo@linaro.org>
>> ---
>>
>> I'm about to ask Linus to pull this patch through the devicetree/merge
>> branch along with the of_alias revert.
>>
>>  drivers/tty/serial/imx.c |   13 ++++---------
>>  1 files changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
>> index 827db76..7e91b3d 100644
>> --- a/drivers/tty/serial/imx.c
>> +++ b/drivers/tty/serial/imx.c
>> @@ -1286,22 +1286,17 @@ static int serial_imx_resume(struct platform_device *dev)
>>  static int serial_imx_probe_dt(struct imx_port *sport,
>>               struct platform_device *pdev)
>>  {
>> +     static int portnum = 0;
>
> would it be better to use an IDR here ?

Hmmm, I've not looked at idr before.  Yes, it would probably be the
right thing to do.  This patch is needed to fix a build failure, but
when it is reworked for v3.2 I think idr should be considered.
Thanks!

g.
