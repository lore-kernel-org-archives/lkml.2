Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1BLR46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:56:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42466 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1BLR4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:56:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kANsUR0IbPP8KPEDhPSBj6E4e6b2W/mkePnKhpd2lLVZiDbowQSZPMPmjPpT8H3LhR
         YXH6OVI7K8lURDQfRiryoztJwAmtFJQzd0iCcdBGopYgdMlrxq/cNH5IinOgh8JG5Ix3
         y52xr9W7UTguR6A8bfhN7fAOeJML9qx2DG7cw=
MIME-Version: 1.0
In-Reply-To: <4D56C79B.2060201@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-3-git-send-email-tj@kernel.org>
	<4D56C79B.2060201@kernel.org>
Date: Sat, 12 Feb 2011 18:56:52 +0100
X-Google-Sender-Auth: 7co9FORDssRjdP10-pHofrR9GS0
Message-ID: <AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in acpi_numa_memory_affinity_init()
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 6:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> -             if ((nd->start | nd->end) == 0)
>> -                     node_clear(node, nodes_parsed);
>
> after change
> looks like nodes_parsed is not set anymore for node that only have hotplug memory.

Yeap, which matches the above node_clear().  If the node was already
occupied, the bit would already be set.  If not, the above
node_clear() would clear it, so the same result.  The code was quite
convoluted.

Thanks.

-- 
tejun
