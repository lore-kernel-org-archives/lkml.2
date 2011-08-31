Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1HaC2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 22:28:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52321 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1HaC2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 22:28:53 -0400
X-AuditID: cbfee61b-b7b7fae000005864-be-4e5d9c63215c
Date: Wed, 31 Aug 2011 11:28:28 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
In-reply-to: <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <4E5D9C4C.1090808@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Thunderbird/3.1.7
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
 <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
X-OriginalArrivalTime: 31 Aug 2011 02:29:28.0213 (UTC)
 FILETIME=[CEA4F450:01CC6785]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static void samsung_drm_connector_destroy(struct drm_connector *connector)
>> +{
>> +       struct samsung_drm_connector *samsung_connector =
>> +               to_samsung_connector(connector);
>> +
>> +       DRM_DEBUG_KMS("%s\n", __FILE__);
>> +
>> +       drm_sysfs_connector_remove(connector);
>> +       drm_connector_cleanup(connector);
>> +       connector->dev->mode_config.num_connector--;
>
> I wonder if num_connector-- should be in drm_connector_cleanup()..
>

Right, num_connector and num_encoder of mode_config should be decreased
in the cleanup functions, but currently drm driver is missing it.

I sent the patch.

Thanks.
