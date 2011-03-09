Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1CIQ26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:28:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34443 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1CIQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jumeanoOR5FbM94kiZ4TY0qvjmF5YZ2TPwCzTggXdDKKdF/OWrXY4l66fuE77x+NgN
         s6M8+HbXNUScSOg+NFd3T/g5dd2cDLQVMy5+SjZJygcN9FdMiq96+riwwY4XhOJnR7Rf
         2wcJKaIuWvStKFgAks67/1WfisnGru6QL32ug=
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 17:28:54 +0100
Message-ID: <AANLkTi=3xRFt-p+HUMWwTUcUzFaxY6y9bovJiqdHTwrn@mail.gmail.com>
Subject: problem with ccflags := -Werror in Makefiles when building with gcc 4.6.0
From: Douglas Mencken <dougmencken@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with gcc 4.6.0 with the new type of warnings introduced,
-Wunused-but-set-variable, many directories with ccflags set to
-Werror in Makefile fail to build.

Example:
> arch/powerpc/kernel/align.c:704:33: error: variable 'instruction' set but not used [-Werror=unused-but-set-variable]
> cc1: all warnings being treated as errors

I'm currently using the following workaround to get rid of `-Werror':

list_of_makefiles=`find . -name Makefile -print0 | xargs -0 grep -H
"ccflags" | grep "\-Werror" | \
                   sed "s/Makefile:/Makefile@\t/g" | cut -d'@' -f1`
echo "${list_of_makefiles}" | while read the_makefile
do
  sed -i 's/-Werror//g' "${the_makefile}"
done

I wish to be personally CC'ed the answers/comments posted to the list
in response.
