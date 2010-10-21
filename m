Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0JUQWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:22:17 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:44801 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750783Ab0JUQWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:22:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 12:22:15 EDT
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: FIUYLnwVM1mKWsg4.P3WYs7hV8u5wqNBORw0kTc3z1vhXmK
 UV1TOH0JYc9HSpJT5HqJXoeC2aG5XLq64lXRwIeYqCTyHgxVZps.uPMo2.4w
 d0LOPnuG1l9rLEN6RLZEbiXMBDjWi.fmFY4Uci.GpUJQLTg1Txtu2Y5knS7I
 j_mtcu.NMl5YD5OwawmgO2IKO1qRuNwr3dwjs_YC77T9OcVjIlojuFuITMe1
 yKV7uEkxTc9agLVTW1pZ.Yen8XJrWZ9SUH56vCyYbWocjmXZqnSiVxDZxxEL
 A5vfu1EUPQlr_45XRERlJZpcZ0dv4
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CC06721.8020308@schaufler-ca.com>
Date: Thu, 21 Oct 2010 09:15:29 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com> <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com> <1287506215.2530.187.camel@localhost.localdomain> <20101019165530.GT19804@ZenIV.linux.org.uk> <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com> <1287528546.2530.277.camel@localhost.localdomain> <20101020143845.GB22271@elte.hu> <1287585996.2530.294.camel@localhost.localdomain> <20101020151555.GC22271@elte.hu>
In-Reply-To: <20101020151555.GC22271@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/20/2010 8:15 AM, Ingo Molnar wrote:
> * Eric Paris <eparis@redhat.com> wrote:
>
>> On Wed, 2010-10-20 at 16:38 +0200, Ingo Molnar wrote:
>>> * Eric Paris <eparis@redhat.com> wrote:
>>>
>>>> Executive summary of the day's work:
>>>> Yesterday morning: 944 bytes per inode in core
>>>> Yesterday night: 24 bytes per inode in core
>>>> Tonight: 4 bytes per inode in core.
>>>>
>>>> That's a x236 time reduction in memory usage.  No I didn't even start looking 
>>>> at a freezer.  Which could bring that 4 down to 0, but would add a scalability 
>>>> penalty on all inodes when IMA was enabled.
>>> Why not use inode->i_security intelligently? That already exists so that way 
>>> it's 0 bytes.
>>>
>>> Thanks,
>> It still wouldn't be 0 bytes since there would be a 1-1 mapping from inode to 
>> i_security structs. [...]
> Only for IMA-affected files, right?
>
> My point is to keep it 0 overhead for the _non IMA common case_.
>
>> The real reason I don't pursue this route is because of the litany of different 
>> ways this pointer is used in different LSMs (or not used at all.)  And we all know 
>> that LSM authors aren't known for seeing the world the same way as each other.  As 
>> a maintainer of one of those LSMs even I'm scared to try pushing that forward....
> Ugh. That's a perfect reason to do it exactly like i suggested.

If you would like to make a proposal on LSM stacking other than
the traditional "rip the LSM out" I am sure that everyone in the
IMA, SELinux, TOMOYO, AppArmor and Smack communities would be
happy to have a look. Short of having a viable mechanism for
multiple LSMs to coexist IMA needs its separate space. Yes, people
do use both IMA and LSMs on the same machine at the same time.


> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

