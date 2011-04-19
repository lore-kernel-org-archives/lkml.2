Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1DSXlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:41:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47129 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1DSXla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:41:30 -0400
Message-ID: <4DAE1DA2.2070105@linux.vnet.ibm.com>
Date: Tue, 19 Apr 2011 16:41:22 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "M. Mohan Kumar" <mohan@in.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH] net/9p: Handle get_user_pages_fast return
 properly
References: <1302856173-10566-1-git-send-email-mohan@in.ibm.com> <4DA85BDC.5030407@linux.vnet.ibm.com> <201104192054.49797.mohan@in.ibm.com>
In-Reply-To: <201104192054.49797.mohan@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 08:24 AM, M. Mohan Kumar wrote:
> On Friday 15 April 2011 8:23:16 pm Venkateswararao Jujjuri wrote:
>>> -		if (err != -ERESTARTSYS)
>>> +		if (err != -ERESTARTSYS&&   err != -EFAULT)
>> Please analyze other errors that could be returned by
>> c->trans_mod->request()
>> if they need any handling here.
> Thanks JV, but we don't need to handle other errors as of now.
*request could also return -EIO and -ENOMEM.
As you said, may be we should leave the default behavior on these 
errors(suspend the channel).

Thanks,
JV
> I will post a V2 patch with retaining printing error message.
> ----
> M. Mohan Kumar

