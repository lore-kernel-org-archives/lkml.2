Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0FCGqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:46:34 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54956 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0FCGqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=us2usyqOldxDPopMfERL/zidDR20PX0wR3sdJp47Gmo14iDVfIurVXeqmRnuJpVXf+
         6WPemJNDWLUdxfsiJBTPVrEHflyeSpp39qsEEWt1Zs4bGkgvE8nsrI172a3/9xprsUEV
         yPeNO4YQiqxZ7uRpTauecuP1B7IKcfvkJd2H8=
Subject: Re: [PATCH] kobject: Suppress compiler warning with gcc 3.x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100603062314.GB5580@cr0.nay.redhat.com>
References: <201006030523.o535NA16029042@www262.sakura.ne.jp>
	 <1275543101.29413.76.camel@edumazet-laptop>
	 <20100603055515.GA5580@cr0.nay.redhat.com>
	 <m1y6ewr6vf.fsf@fess.ebiederm.org>
	 <20100603062314.GB5580@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 08:46:27 +0200
Message-ID: <1275547587.2456.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 juin 2010 à 14:23 +0800, Américo Wang a écrit :
> On Wed, Jun 02, 2010 at 11:02:28PM -0700, Eric W. Biederman wrote:
> >Américo Wang <xiyou.wangcong@gmail.com> writes:
> >
> >> On Thu, Jun 03, 2010 at 07:31:41AM +0200, Eric Dumazet wrote:
> >>>Le jeudi 03 juin 2010 à 14:23 +0900, Tetsuo Handa a écrit :
> >>>> Gcc 3.x generates a warning
> >>>> 
> >>>>   include/linux/sysfs.h:183: warning: parameter has incomplete type
> >>>> 
> >>>> on each file.
> >>>> Suppress the warning by moving the definition of "enum kobj_ns_type"
> >>>> to before "#include <linux/sysfs.h>".
> >>>> 
> >>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >>>
> >>>
> >>>I was about to submit same patch, but I was also reverting 27eabc7cb4b3
> >>>(sysfs: Don't use enums in inline function declaration.)
> >>>
> >>>So that sysfs_exit_ns() prototype is consistent regardless of
> >>>CONFIG_SYSFS
> >>>
> >>>What do you think ?
> >>>
> >>
> >> This looks odd, in sysfs.h we do have a forward declaration of
> >> enum kobj_ns_type... I am wondering why gcc 3.x doesn't recognize it.
> >
> >Because the replacement is an inline, and we are passing the enum by value
> >gcc wants to see the full definition, at the point where the inline function
> >is declared.
> >
> 
> But sysfs_exit_ns() is not inlined if CONFIG_SYSFS here.
> 

 
# gcc -v
Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=posix
--disable-checking --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-java-awt=gtk
--host=i386-redhat-linux
Thread model: posix
gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)


# cat try.c
enum kobj_ns_type;
void sysfs_exit_ns(enum kobj_ns_type type, const void *tag);
int main(int argc, char *argv[])
{
	return 0;
}
# gcc -O2 -Wall -o try try.c
try.c:2: warning: parameter has incomplete type
#


