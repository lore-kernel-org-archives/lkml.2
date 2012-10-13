Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2JMWVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 18:21:55 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:36713 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754203Ab2JMWVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 18:21:54 -0400
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=utf-8
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <201210132052.09835.arnd@arndb.de>
Date: Sun, 14 Oct 2012 02:21:42 +0400
Cc: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Content-Transfer-Encoding: 8BIT
Message-Id: <E4F29864-3D97-4839-BC4E-6DCFDAC5447C@dubeyko.com>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210132052.09835.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14, 2012, at 12:52 AM, Arnd Bergmann wrote:

> On Friday 05 October 2012, 김재극 wrote:
>> +const char *media_ext_lists[] = {
>> +       "jpg",
>> +       "gif",
>> +       "png",
>> +       "avi",
>> +       "divx",
>> +       "mp4",
>> +       "mp3",
>> ...
> 
>> + * Set multimedia files as cold files for hot/cold data separation
>> + */
>> +static inline void set_cold_file(struct inode *inode, const unsigned char *name)
>> +{
>> +       const char **extlist = media_ext_lists;
>> +
>> +       while (*extlist) {
>> +               if (!is_multimedia_file(name, *extlist)) {
>> +                       F2FS_I(inode)->is_cold = 1;
>> +                       break;
>> +               }
>> +               extlist++;
>> +       }
>> +}
> 
> This is a very clever way of categorizing files by their name, but I wonder if hardcoding
> the list of file name extensions at in the kernel source is the best strategy. Generally
> I would consider this to be a policy that should be configurable by the user.
> 
> Unfortunately I can't think of a good interface to configure this, but maybe someone
> else has a useful idea. Maybe the list can be stored in the superblock and get written
> at mkfs time from the same defaults, but with the option of overriding it using
> a debugfs tool.
> 

By the way, how about extended attributes? It is possible to save in extended attribute a hint about file's content nature during creation operation or later. Moreover, extended attribute gives possibility to change hint after renaming operation, for example.

With the best regards,
Vyacheslav Dubeyko.

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

