Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1EDTdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1EDTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:33:30 -0400
Message-ID: <4DC1AA08.7000502@redhat.com>
Date: Wed, 04 May 2011 15:33:28 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <16735.1304537498@localhost>
In-Reply-To: <16735.1304537498@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 03:31 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 13:58:39 EDT, Josef Bacik said:
>
>> +#define SEEK_HOLE	3	/* seek to the closest hole */
>> +#define SEEK_DATA	4	/* seek to the closest data */
>
> Comments here need nearest/next fixing as well - otherwise the ext[34] crew may
> actually implement the commented semantics. ;)
>

Balls, thanks I'll fix that.

> Other than that, patch 1/2 looks OK to me (not that there's much code to
> review), and 2/2 *seems* sane and implement the "next" semantics, though I only
> examined the while/if structure and am assuming the btrfs innards are done
> correctly.  In particular, that 'while (1)' looks like it can be painful for a
> sufficiently large and fragmented file (think a gigabyte file in 4K chunks,
> producing a million extents), but I'll let a btrfs expert analyse that
> performance issue ;)
>

Heh well we do while (1) in btrfs _everywhere_, so this isn't anything 
new, tho I should probably throw a cond_resched() in there.  Thanks,

Josef
