Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2FZQ7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:59:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34985 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433Ab2FZQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:59:21 -0400
Message-ID: <4FE9EA65.4020005@acm.org>
Date: Tue, 26 Jun 2012 11:59:17 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Srinivas_G_Gowda@Dell.com
CC: tcminyard@gmail.com, linux-kernel@vger.kernel.org, openipmi@mvista.com
Subject: Re: [PATCH] ipmi: setting OS name as Linux in BMC
References: <4FE9A3EB.50505@dell.com> <4FE9B827.80300@dell.com> <4FE9BBA4.8070407@acm.org> <4FE9DD1D.9020803@dell.com>
In-Reply-To: <4FE9DD1D.9020803@dell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 11:02 AM, Srinivas_G_Gowda@Dell.com wrote:
> Corey, Thanks for the comments. I was looking at the way BMC presence 
> is detected. Thought it would be appropriate that BMC is told about 
> the OS information -- Soon after ipmi_si driver detects 
> BMC(Get_Device_ID) and before the driver starts doing anything useful. 
> Looked like a quick clean getaway..! Looking at the ipmi_msghandler, I 
> don't see how we will be able to do this during the driver 
> initialization process. I could probably do it inside 
> ipmi_register_smi in ipmi_msghandler. But I still prefer doing this in 
> ipmi_si itself. Please let me know your thoughts on this. Thanks, G 

The trouble is that there are other interfaces (that are unfortunately 
not in the mainstream kernel, but that's a different story) that would 
not benefit from this if you put it in ipmi_si.  That's a low-level 
interface, this is a higher-level function and belongs.

Look at get_guid() called from ipmi_register_smi() in 
ipmi_msghandler.c.  It's not that hard.

-corey
