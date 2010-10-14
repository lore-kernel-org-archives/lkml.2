Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0JNTXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:23:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56121 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab0JNTXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hpIG+3DQAAbGMnHRTwvFJ+AN6hj8/38v6WOJq3de1HSHf3R8BdbM/seZIN2yO0BvfA
         54F4xQriwVYwNab86UyiBTqHQUP9Fyq2J+NEdoB+zG7EFlxyPNyimJ2Zu+bLa3kyHRNJ
         pNYXKxzCdq/r9q5CuhLUnojxH6S3flaQmJr04=
MIME-Version: 1.0
In-Reply-To: <20101014121627.2405e99a.akpm@linux-foundation.org>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	<AANLkTin1RjhDZp6w-jumRnZ1-Hx3zio7SrZtZqummok2@mail.gmail.com>
	<20101014121627.2405e99a.akpm@linux-foundation.org>
Date: Thu, 14 Oct 2010 21:23:18 +0200
Message-ID: <AANLkTimZ5KN9n0in52eWhOA+yjDNbzjXCx4H=HnzpwHf@mail.gmail.com>
Subject: Re: mmotm 2010-10-13-17-13 uploaded
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/14 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 14 Oct 2010 12:26:45 +0200
> Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:
>
>> 2010/10/14  <akpm@linux-foundation.org>:
>> > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
>>
>> linux-next.patch breaks things
>>
>>   GEN     /home/test/linux-2.6-obj/Makefile
>>   HOSTCC  scripts/kconfig/zconf.tab.o
>> In file included from scripts/kconfig/zconf.tab.c:2462:0:
>> scripts/kconfig/lex.zconf.c:2425:7: error: conflicting types for 'zconf_curname'
>> /home/test/linux-2.6-mm/scripts/kconfig/lkc.h:79:13: note: previous
>> declaration of 'zconf_curname' was here
>> scripts/kconfig/lex.zconf.c: In function 'zconf_curname':
>> scripts/kconfig/lex.zconf.c:2427:2: warning: return discards
>> qualifiers from pointer target type
>> make[3]: *** [scripts/kconfig/zconf.tab.o] Error 1
>> make[2]: *** [silentoldconfig] Error 2
>> make[1]: *** No rule to make target `include/config/auto.conf', needed
>> by `include/config/kernel.release'.  Stop.
>> make: *** [sub-make] Error 2
>>
>
> Something went wrong with the zconf_curname() constification.
>
> lex scripts never seem to get along well with the build dependency
> systems - did you try a `make mrproper' and a rebuild?

Yes and no.

Yes, because I've got mrproper for KERNEL_DIR, and no, because I don't
have this for KERNEL_OBJ_DIR
        def kernel_make_mrproper(self):
                print("make mrproper")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make mrproper &> /dev/null")

        def kernel_make_clean(self):
                print("make clean")
                os.system("cd " + self.config["KERNEL_DIR"] + " &&
LANG=\"C\" make O=" + self.config["KERNEL_OBJ_DIR"] + " clean &>
/dev/null")

I'll fix my script :)


-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
