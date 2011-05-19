Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab1ESR31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:29:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596Ab1ESR30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:29:26 -0400
Message-ID: <4DD55364.8070002@oracle.com>
Date: Thu, 19 May 2011 10:29:08 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Implement llseek()
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com> <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com> <20110519110531.GB6357@lst.de>
In-Reply-To: <20110519110531.GB6357@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DD55373.0049:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 04:05 AM, Christoph Hellwig wrote:
> On Wed, May 18, 2011 at 07:44:44PM -0700, Sunil Mushran wrote:
>> Unwritten (preallocated) extents are considered holes because the file system
>> treats reads to such regions in the same way as it does to holes.
> How does this work for the case of an unwrittent extent that has been
> written to in the pagecache but not converted yet?  Y'know the big data
> corruption and flamewar that started all this?

We don't delay splitting the extent. It is split in ->write_begin(). Delaying
it will be a challenge as we have to provide cache coherency across the
cluster.

