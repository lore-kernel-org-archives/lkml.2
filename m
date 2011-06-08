Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1FHSuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:50:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31316 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1FHSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:50:01 -0400
Message-ID: <4DEFC43B.1080802@oracle.com>
Date: Wed, 08 Jun 2011 11:49:31 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Amir G." <amir73il@users.sourceforge.net>
CC: Mike Snitzer <snitzer@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
In-Reply-To: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DEFC44F.0174:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 11:26 AM, Amir G. wrote:
> 2. Data blocks are never copied
> The move-on-write technique is used to re-allocate data blocks on rewrite
> instead of copying them.
> This is not something that can be done when the snapshot is stored on
> external storage, but it can done when the snapshot file lives in the fs.

But does that not lead to fragmentation. And if I am understanding this,
the fragmentation will not resolve after dropping the snapshot. So while
you do save the overhead on write, you make the user pay on all future
reads (that need to hit the disk).
