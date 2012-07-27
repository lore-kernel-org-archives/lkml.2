Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2G0ALW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:11:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43878 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab2G0ALV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:11:21 -0400
Message-ID: <5011DC84.6010003@zytor.com>
Date: Thu, 26 Jul 2012 17:10:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, safford@us.ibm.com
Subject: Re: [PATCH 1/2] tpm: Move tpm_get_random api into the TPM device
 driver
References: <1339094567.21398.2.camel@key-ThinkPad-W510> <1339094834.21398.4.camel@key-ThinkPad-W510>
In-Reply-To: <1339094834.21398.4.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:47 AM, Kent Yoder wrote:
> Move the tpm_get_random api from the trusted keys code into the TPM
> device driver itself so that other callers can make use of it. Also,
> change the api slightly so that the number of bytes read is returned in
> the call, since the TPM command can potentially return fewer bytes than
> requested.
>
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

I see a second problem with this patch: you don't seem to handle the 
case where you get a short return anywhere in your code.  Presumably 
this should either be considered an error condition, or you need to 
create a private wrapper which can loop and make additional requests.

As it is if you get a short return you simply proceed as if you had 
gotten what you requested, since this was not an error mode supported by 
the old code.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

