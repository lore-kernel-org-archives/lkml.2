Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2GWWH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:07:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab2GWWHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:07:52 -0400
Message-ID: <500DCB34.6050209@nod.at>
Date: Tue, 24 Jul 2012 00:07:48 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: st_size of a symlink
References: <500D73FF.1070504@nod.at> <alpine.LNX.2.00.1207231959410.1922@swampdragon.chaosbits.net> <20120723202224.GH31729@ZenIV.linux.org.uk> <alpine.LNX.2.00.1207232243110.1922@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1207232243110.1922@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2012 22:47, Jesper Juhl wrote:
>> Fix it _how_?
>
> By returning the size as the number of bytes in the name the link is
> currently pointing at.

This is not easy.
procfs has no clue where the link pointing at.
The information is generated while accessing the link.
tmpfs on the other hand has this information because symlinks get only 
changed through tmpfs...

>>   By retrying readlink() with bigger buffer.
>> With procfs there's just a few more ways the readlink() output can
>> change, that's all.
>>
> Still not a good reason to just return 0 IMHO.

IMHO the lstat() and readlink() manpages have to be more precise about 
st_size.

Thanks,
//richard
