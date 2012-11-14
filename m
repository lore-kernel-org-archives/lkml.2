Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141Ab2KNK5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:57:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:2126 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab2KNK5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:57:15 -0500
Message-ID: <50A378C0.70406@parallels.com>
Date: Wed, 14 Nov 2012 14:56:00 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into inotify_inode_mark
References: <20121112101440.665694060@openvz.org> <2092535.8S9EcgmZCZ@deuteros> <50A37692.1010500@parallels.com> <1491483.8kFV7tRC1p@deuteros>
In-Reply-To: <1491483.8kFV7tRC1p@deuteros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> How much space does a typical file system need to encode a handle? Am I
>>> right that for must it is just a few bytes? (I just glanced at the code
>>> so I might be wrong.) In which case, could the handle buffer be allocated
>>> dynamically depending on the underlying filesystem? Perhaps adding a
>>> facility to query a filesystem about its maximum handle buffer needs? Do
>>> you think the saving would justify this extra work?
>>
>> Well, the MAX_HANDLE_SZ is taken from NFSv4 and is 128 bytes which is quite
>> big for inotify extension indeed. The good news is that this amount of bytes
>> seem to be required for the most descriptive fhandle -- with info about
>> parent, etc. We don't need such, we can live with shorter handle, people
>> said that 40 bytes was enough for that.
>>
>> However, your idea about determining the handle size dynamically seems
>> promising. As far as I can see from the code we can call for encode_fh with
>> size equals zero and filesystem would report back the amount of bytes it
>> requires for a handle.
>>
>> We can try going this route, what do you think?
> 
> Sounds much better since that would only add one pointer to the watch 
> structure in the normal case.
> 
> Also at checkpoint time it will use only a few bytes (compared to 64) for the 
> encode buffer for most filesystems. This part is probably not that important 
> but still a win.

No, the thing is -- we need to know the handle _before_ we start checkpoint.
More exactly -- at the time the inotify_add_watch is called. So the memory save
would be not that big.

> Regards,
> 
> Tvrtko

Thanks,
Pavel

