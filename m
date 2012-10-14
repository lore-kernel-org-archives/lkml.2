Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2JNMHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 08:07:08 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:45529 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751935Ab2JNMHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 08:07:06 -0400
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=utf-8
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <1350198545.1915.233.camel@kjgkr>
Date: Sun, 14 Oct 2012 16:06:54 +0400
Cc: Arnd Bergmann <arnd@arndb.de>,
        =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Content-Transfer-Encoding: 8BIT
Message-Id: <A7BD3CDD-330C-498A-BB36-631DE6B9777C@dubeyko.com>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210132052.09835.arnd@arndb.de> <E4F29864-3D97-4839-BC4E-6DCFDAC5447C@dubeyko.com> <1350198545.1915.233.camel@kjgkr>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14, 2012, at 11:09 AM, Jaegeuk Kim wrote:

> 2012-10-14 (일), 02:21 +0400, Vyacheslav Dubeyko:
>> On Oct 14, 2012, at 12:52 AM, Arnd Bergmann wrote:
>> 
>>> On Friday 05 October 2012, 김재극 wrote:
>>>> +const char *media_ext_lists[] = {
>>>> +       "jpg",
>>>> +       "gif",
>>>> +       "png",
>>>> +       "avi",
>>>> +       "divx",
>>>> +       "mp4",
>>>> +       "mp3",
>>>> ...
>>> 
>>>> + * Set multimedia files as cold files for hot/cold data separation
>>>> + */
>>>> +static inline void set_cold_file(struct inode *inode, const unsigned char *name)
>>>> +{
>>>> +       const char **extlist = media_ext_lists;
>>>> +
>>>> +       while (*extlist) {
>>>> +               if (!is_multimedia_file(name, *extlist)) {
>>>> +                       F2FS_I(inode)->is_cold = 1;
>>>> +                       break;
>>>> +               }
>>>> +               extlist++;
>>>> +       }
>>>> +}
>>> 
>>> This is a very clever way of categorizing files by their name, but I wonder if hardcoding
>>> the list of file name extensions at in the kernel source is the best strategy. Generally
>>> I would consider this to be a policy that should be configurable by the user.
>>> 
>>> Unfortunately I can't think of a good interface to configure this, but maybe someone
>>> else has a useful idea. Maybe the list can be stored in the superblock and get written
>>> at mkfs time from the same defaults, but with the option of overriding it using
>>> a debugfs tool.
>>> 
>> 
>> By the way, how about extended attributes? It is possible to save in extended attribute a hint about file's content nature during creation operation or later. Moreover, extended attribute gives possibility to change hint after renaming operation, for example.
>> 
> 
> I think xattr is not a proper way to communicate between file system and
> users.

I don't understand why you think that xattr is not proper way. Extended attributes are the way of adding some additional properties to filesystem object, from my point of view.

> How about fadvise()?
> 

The fadvise() is a good suggestion. But, as I can understand, such solution requires using fadvise() during application implementation. So, from one point of view, it exists many applications that doesn't use fadvise() and, from another point of view, developers change style of coding not so easy.

Extended attributes are more flexible way, from my point of view. The xattr gives possibility to make hint to filesystem at any time and without any dependencies with application's functional opportunities. Documented way of using such extended attributes gives to user flexible way of manipulation of filesystem behavior (but I remember that you don't believe in an user :-)).

So, I think that fadvise() and extended attributes can be complementary solutions.

Anyway, hardcoding or saving in filesystem list of file extensions is a nasty way. It can be not safe or hardly understandable by users the way of reconfiguration filesystem by means of tunefs or debugfs with the purpose of file extensions addition in such "black-box" as TV or smartphones, from my point of view.

With the best regards,
Vyacheslav Dubeyko.

>> With the best regards,
>> Vyacheslav Dubeyko.
>> 
>>> 	Arnd
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Jaegeuk Kim
> Samsung
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

