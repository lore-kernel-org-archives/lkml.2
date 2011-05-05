Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1EETZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:25:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1EETZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RXhmCOU1YxsynW3cvlX4EJ2zPosFfNAgZVBMFep5OcKe5fJq6PtWL39RhGDx5VW/+2
         0b1P6+c7/ccWFm+6etoZz+zPLFCPM+1Gn17eHyG3n4ZkmyRdzfb6+xa7CQA9lbKqHhoO
         jWhAnPTi3pfvqswlQhxUF/P0pPiE4pVeC/RB8=
Message-ID: <4DC2F84F.8030107@gmail.com>
Date: Thu, 05 May 2011 21:19:43 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com>
In-Reply-To: <1304531920-2890-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/05/2011 19:58, Josef Bacik ha scritto:
> +		if (offset>= i_size_read(inode)) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -ENXIO;
> +		}
> +		offset = i_size_read(inode);
> +		break;

I can add that generic_file_llseek_unlocked means *unlocked* so you 
shouldn't unlock any mutex but only return a value. The current version, 
in case of SEEK_END uses directly i_size indeed, so maybe I'm missing 
something.

Marco
