Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0LISyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:54:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:45911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0LISyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:54:04 -0500
Message-ID: <4D01259D.2010409@kernel.org>
Date: Thu, 09 Dec 2010 19:53:17 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-6-git-send-email-tj@kernel.org> <4D011E05.5030205@ru.mvista.com>
In-Reply-To: <4D011E05.5030205@ru.mvista.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 18:53:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sergei.

On 12/09/2010 07:20 PM, Sergei Shtylyov wrote:
>> +    /*
>> +     * Media is considered to be present if TUR succeeds or fails with
>> +     * sense data indicating something other than media-not-present
>> +     * (ASC 0x3a).
>> +     */
>> +    if (!scsi_status_is_good(retval) &&
>> +        (!scsi_sense_valid(sshdr) || sshdr->asc == 0x3a)) {
>> +        /*
>> +         * Probably not media in the device.  Mark as changed, and
> 
>    s/not/no/

Updated patch already posted.  Thanks.

-- 
tejun
