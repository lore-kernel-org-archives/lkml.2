Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1IUNCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:02:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53923 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1IUNCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110921124936.GA25620@sirena.org.uk>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
	<20110921124936.GA25620@sirena.org.uk>
Date: Wed, 21 Sep 2011 14:02:43 +0100
X-Google-Sender-Auth: 2iLWuxsPBmxs1VRqzSTGwFcNTs0
Message-ID: <CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 1:49 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Sep 21, 2011 at 01:01:48PM +0100, Daniel Drake wrote:
>
>> @@ -37,6 +38,9 @@ struct mfd_cell {
>>       void                    *platform_data;
>>       size_t                  pdata_size;
>>
>> +     /* association with device tree node (optional) */
>> +     struct device_node      *of_node;
>> +
>
> This doesn't seem great as it means that the mfd_cells can't be static
> data, they have to be allocated per device.  Why can't the MFD cells get
> at the OF node by using the parent device in the same way as they
> (mostly) get platform data at the minute?

Thanks for reviewing.
The data can still be static, not needing allocation, it just has to
be modified at runtime. See patch 2.

Not sure how the MFD cells could get at the OF node by using the
parent device - if the parent device had a OF node, wouldn't this
correspond to the parent instead of the child? Also, as far as I can
see, platform data is passed to the child in exactly the same way - by
including it in the mfd_cell definition - see mfd_add_device():

	if (cell->pdata_size) {
		ret = platform_device_add_data(pdev,
					cell->platform_data, cell->pdata_size);
		if (ret)
			goto fail_res;
	}

Daniel
