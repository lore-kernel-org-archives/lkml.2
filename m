Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0FCFv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:51:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58125 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0FCFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KWQ8w7wEawqFEFZgs5cgSbfmJX+G/5r4Qd/BYsGYv6XDC3rHZuWL4wmuHuxIJublFB
         8kpKgfTZEU+J/r9AVh5bIJ1g30E2wkzsXB5Y23GVZYO25CdR/n3dp2OJGxiV/DkUoy4R
         sp8bb/95mBnyWzekFti6o8oKbGYyPmS2evHKY=
Date: Thu, 3 Jun 2010 13:55:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kobject: Suppress compiler warning with gcc 3.x
Message-ID: <20100603055515.GA5580@cr0.nay.redhat.com>
References: <201006030523.o535NA16029042@www262.sakura.ne.jp>
 <1275543101.29413.76.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275543101.29413.76.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 07:31:41AM +0200, Eric Dumazet wrote:
>Le jeudi 03 juin 2010 à 14:23 +0900, Tetsuo Handa a écrit :
>> Gcc 3.x generates a warning
>> 
>>   include/linux/sysfs.h:183: warning: parameter has incomplete type
>> 
>> on each file.
>> Suppress the warning by moving the definition of "enum kobj_ns_type"
>> to before "#include <linux/sysfs.h>".
>> 
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
>
>I was about to submit same patch, but I was also reverting 27eabc7cb4b3
>(sysfs: Don't use enums in inline function declaration.)
>
>So that sysfs_exit_ns() prototype is consistent regardless of
>CONFIG_SYSFS
>
>What do you think ?
>

This looks odd, in sysfs.h we do have a forward declaration of
enum kobj_ns_type... I am wondering why gcc 3.x doesn't recognize it.
