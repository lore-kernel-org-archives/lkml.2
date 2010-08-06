Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838Ab0HFBIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:08:11 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:53422 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760703Ab0HFBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:08:09 -0400
Message-ID: <4C5B6065.7000700@free.fr>
Date: Fri, 06 Aug 2010 03:07:49 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mount notification question
References: <4C5734A2.7070400@free.fr> <4C59B444.7080609@nortel.com>
In-Reply-To: <4C59B444.7080609@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 08:41 PM, Chris Friesen wrote:
> On 08/02/2010 03:12 PM, Daniel Lezcano wrote:
>    
>> Hi all,
>>
>> is there a way to be notified when a mount occurs on the system ?
>>      
> Have you looked on google?  The link is a bit misleading but they do
> give a way to do it (not using inotify).
>
> http://stackoverflow.com/questions/1113176/how-could-i-detect-when-a-directory-is-mounted-with-inotify
>    

Thanks a lot for the pointer. I am not sure this solution will work, 
because it is inadequate for watching a specific location in a container 
context separated by the mount and the network namespaces. We have 
multiple mount points at the same place (eg. the mount point 
inheritance, the container configuration and the init scripts may mount 
/dev or /var/run several time) and the network namespace separation will 
make impossible to watch udev event via a netlink socket. I didn't look 
at the inotify implementation but IMHO, it should be worth to add 
IN_MOUNT and IN_UNMOUNT events for inotify no ?

Thanks
   -- Daniel

