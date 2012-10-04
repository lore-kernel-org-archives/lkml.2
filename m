Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2JDGH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:07:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab2JDGHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:07:23 -0400
Message-ID: <506D2798.7060001@suse.de>
Date: Thu, 04 Oct 2012 08:07:20 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        tj@kernel.org, axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v3 11/26] block: Add submit_bio_wait(), remove
 from md
References: <1348526106-17074-1-git-send-email-koverstreet@google.com> <1348526106-17074-12-git-send-email-koverstreet@google.com> <20121002194132.GF3283@redhat.com> <20121002201105.GL26488@google.com>
In-Reply-To: <20121002201105.GL26488@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 10:11 PM, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 03:41:32PM -0400, Vivek Goyal wrote:
>> On Mon, Sep 24, 2012 at 03:34:51PM -0700, Kent Overstreet wrote:
>>> Random cleanup - this code was duplicated and it's not really specific
>>> to md.
>>>
>>> Also added the ability to return the actual error code.
>>
>> Who is going to make use of actual error code and why checking
>> BIO_UPTODATE is not sufficient (as existing code is doing)?
>
> Some things do, though it's not common and I forget where I saw it -
> checking for -ENOTSUPPORTED vs. other stuff
>
There are also additional error codes like -ENOLINK when the nexus 
is dropped. Quite useful in multipathed or clustered environs.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
