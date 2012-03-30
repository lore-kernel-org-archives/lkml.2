Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883Ab2C3NXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:23:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab2C3NXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:23:15 -0400
Message-ID: <4F75B3B2.7030901@redhat.com>
Date: Fri, 30 Mar 2012 10:22:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] edac: move dimm properties to struct memset_info
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1333039546-5590-3-git-send-email-mchehab@redhat.com> <20120330131037.GB30876@aftab>
In-Reply-To: <20120330131037.GB30876@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-03-2012 10:10, Borislav Petkov escreveu:
> Please don't call it 'memset_info' - this is misleading beyond belief.
> 
> Hmm, what struct memset_info - where the hell is this? It is nowhere to
> be seen in the patches following that one too, WTF?

s/memset_info/dimm_info/

Sorry, I forgot to rename the patch name on the rebase I've renamed
this field (rebase 8?).

> On Thu, Mar 29, 2012 at 01:45:35PM -0300, Mauro Carvalho Chehab wrote:
>> On systems based on chip select rows, all channels need to use memories
>> with the same properties, otherwise the memories on channels A and B
>> won't be recognized.
>>
>> However, such assumption is not true for all types of memory
>> controllers.
>>
>> Controllers for FB-DIMM's don't have such requirements.
>>
>> Also, modern Intel controllers seem to be capable of handling such
>> differences.
>>
>> So, we need to get rid of storing the DIMM information into a per-csrow
>> data, storing it, instead at the right place.
>>
>> The first step is to move grain, mtype, dtype and edac_mode to the
>> per-dimm struct.
> 

