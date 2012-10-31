Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049Ab2JaVnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:43:14 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:37057 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992Ab2JaVm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:42:57 -0400
Message-ID: <50919B5D.9000100@cesarb.net>
Date: Wed, 31 Oct 2012 19:42:53 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        minchan@kernel.org, fschmaus@gmail.com, andor.daam@googlemail.com,
        ilendir@googlemail.com, akpm@linux-foundation.org, mgorman@suse.de
Subject: Re: [PATCH 2/5] mm: frontswap: lazy initialization to allow tmem
 backends to build/run as modules
References: <1351696074-29362-1-git-send-email-dan.magenheimer@oracle.com> <1351696074-29362-3-git-send-email-dan.magenheimer@oracle.com> <50915A5C.8000303@linux.vnet.ibm.com>
In-Reply-To: <50915A5C.8000303@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-10-2012 15:05, Seth Jennings escreveu:
> On 10/31/2012 10:07 AM, Dan Magenheimer wrote:
>> +#define MAX_INITIALIZABLE_SD 32
>
> MAX_INITIALIZABLE_SD should just be MAX_SWAPFILES
>
>> +static int sds[MAX_INITIALIZABLE_SD];
>
> Rather than store and array of enabled types indexed by type, why not
> an array of booleans indexed by type.  Or a bitfield if you really
> want to save space.

Since it is indexed by swap_info_struct's type, and frontswap already 
pokes directly inside the swap_info_structs, it would be even cleaner to 
use a boolean field within the swap_info_struct.

And if you are using a field within the swap_info_struct, you could 
overload the already existing frontswap_map field, which should only 
have any use if you have a frontswap module already loaded. That is, 
move the vzalloc of the frontswap_map to within frontswap's init 
function, and call it outside the swapfile_lock/swapon_mutex. This also 
has the advantage of not allocating the frontswap_map when it is not 
going to be used.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
