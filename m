Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1DSGmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:42:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45544 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1DSGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iHKvdmFH35kczRRNhd0t4Y2xcpqNqTnvYpZ3FamzFiL4I2ei1EatSWUqj0pwD5jC7Z
         Rgpr20/siD5A3cxozG3YeX4iXYoa76VfpVCJUPf3nK8qtC4kQ0t7CPSvUCZxaO2DlzAr
         WsBIjgi5erSA6CoBKERcz3iowO4P9dyD/GLpw=
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 14:42:39 +0800
Message-ID: <BANLkTikYuYVvXiHvi_kr2H7n29k=veThtw@mail.gmail.com>
Subject: LOCALVERSION in setlocalversion
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In scripts/setlocalversion under linux kernel tree, the scripts seems
a little strange.

# scm version string if not at a tagged commit
if test "$CONFIG_LOCALVERSION_AUTO" = "y"; then
        # full scm version string
        res="$res$(scm_version)"
else
        # append a plus sign if the repository is not in a clean
        # annotated or signed tagged state (as git describe only
        # looks at signed or annotated tags - git tag -a/-s) and
        # LOCALVERSION= is not specified
        if test "${LOCALVERSION+set}" != "set"; then
                scm=$(scm_version --short)
                res="$res${scm:++}"
        fi
fi

LOCALVERSION isn't assigned in any place. Only CONFIG_LOCALVERSION
can be assigned in .config file.
Why do we need to check LOCALVERSION at here?

Thanks
Haojian
