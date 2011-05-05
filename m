Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1EETE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:04:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63389 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1EETE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GmyTjx3o93aX6eRQPgqb8I8HHIf7LBqzKeDcK9d2kC21tqJUGypJr6HFLMfoYrYEHL
         lIfF3s+dStZ2xexF+PW/WNER5GaPszhzkezCQy+hqm6xaFFXVqpDRVOcrExgcXmGWzhR
         qw+vml6GLftt/ssFKKjpL6Qxw1we0bdrNRlWg=
Message-ID: <4DC2F372.50601@gmail.com>
Date: Thu, 05 May 2011 20:58:58 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <4DC2F24A.4050304@gmail.com> <4DC2F400.4060903@redhat.com>
In-Reply-To: <4DC2F400.4060903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/05/2011 21:01, Josef Bacik ha scritto:
> On 05/05/2011 02:54 PM, Marco Stornelli wrote:
>> Il 04/05/2011 19:58, Josef Bacik ha scritto:
>>> + if (offset>= i_size_read(inode)) {
>>> + mutex_unlock(&inode->i_mutex);
>>> + return -ENXIO;
>>> + }
>>> + offset = i_size_read(inode);
>>> + break;
>>
>> Here maybe it's possible to use offset bigger than i_size, because
>> i_size_read is "atomic" but something can happen between two calls,
>> isn't it?
>>
>
> We're holding the i_mutex so we are safe, i_size_read is used just for
> consistency sake. Thanks,
>
> Josef
>

Oh, I'm sorry, I misread the patch, ok. Maybe we can use i_size at this 
point without i_size_read.

Marco
