Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab1D2W7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:59:21 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47531 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934073Ab1D2W7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:59:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HmBNgx/v92cE+HyvO/YoyuCCm1xdJYbYcocFoMnyTQ4fbdHiVfJrp/cK3L+LWwCBRhWCu43lvOrn5EwMPsqEm7SUICNgEbJGBkEA18yujqIgkSSG9eveznIjmfVl9Nox;
Date: Fri, 29 Apr 2011 15:59:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: <pefoley2@verizon.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH V2 0/7] kbuild: move scripts/basic/docproc.c to
 scripts/docproc.c
Message-Id: <20110429155915.f9059777.rdunlap@xenotime.net>
In-Reply-To: <4DBB3DD4.9000000@verizon.net>
References: <4DBB3DD4.9000000@verizon.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 18:38:12 -0400 Peter Foley wrote:

> This patchset moves scripts/basic/docproc to scripts/docproc.
> This causes docproc to only be built for *doc targets rather than every
> time the kernel is compiled.
> 
> Patches also attached as requested by Michal Marek.


Please test & fix when using O=output_dir.

$ mkdir DOC1
$ make -j4 O=DOC1 htmldocs

gives:

for dep in dvb media-entities.tmpl media-indices.tmpl v4l; do \
		rm -f lnx-2639-rc5/DOC1/Documentation/DocBook/$dep \
		&& ln -s lnx-2639-rc5/Documentation/DocBook/$dep lnx-2639-rc5/DOC1/Documentation/DocBook/ \
		|| exit; \
	done
  DOCPROC Documentation/DocBook/80211.xml
  DOCPROC Documentation/DocBook/alsa-driver-api.xml
  DOCPROC Documentation/DocBook/debugobjects.xml
/bin/sh: lnx-2639-rc5/DOC1/scripts/docproc: No such file or directory
/bin/sh: lnx-2639-rc5/DOC1/scripts/docproc: No such file or directory
make[2]: *** [Documentation/DocBook/alsa-driver-api.xml] Error 1
make[2]: *** Waiting for unfinished jobs....
  DOCPROC Documentation/DocBook/device-drivers.xml
make[2]: *** [Documentation/DocBook/debugobjects.xml] Error 1
/bin/sh: lnx-2639-rc5/DOC1/scripts/docproc: No such file or directory
make[2]: *** [Documentation/DocBook/device-drivers.xml] Error 1
/bin/sh: lnx-2639-rc5/DOC1/scripts/docproc: No such file or directory
make[2]: *** [Documentation/DocBook/80211.xml] Error 1
make[1]: *** [htmldocs] Error 2
make: *** [sub-make] Error 2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
