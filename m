Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2LDC6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 21:58:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24624 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2LDC6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 21:58:52 -0500
Message-ID: <50BD66D9.8080408@oracle.com>
Date: Mon, 03 Dec 2012 20:58:33 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 16/31] loop: use aio to perform io on the underlying
 file
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com> <1353537671-26284-17-git-send-email-dave.kleikamp@oracle.com> <20121122230628.GV2591@dastard> <50BCDA7B.7080000@oracle.com> <20121204025221.GF32450@dastard>
In-Reply-To: <20121204025221.GF32450@dastard>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 08:52 PM, Dave Chinner wrote:
> On Mon, Dec 03, 2012 at 10:59:39AM -0600, Dave Kleikamp wrote:
>> On 11/22/2012 05:06 PM, Dave Chinner wrote:

>>> And this extra fsync is now not done in the aio path. I.e. the AIO
>>> completion path needs to issue the fsync to maintain correct REQ_FUA
>>> semantics...
>>
>> If this is really necessary, I can fix it.
> 
> Absolutely. If we don't implement FUA properly, we'll end up with
> corrupted filesystems and/or data loss when kernel crashes or
> powerloss occurs. That's not an acceptable outcome, so we need FUA
> to be implemented properly.

Okay, just wanted to make sure.

Thanks,
Shaggy
