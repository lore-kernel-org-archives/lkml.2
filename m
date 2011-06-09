Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1FITnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab1FITnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:43:40 -0400
Message-ID: <4DF12263.3070900@redhat.com>
Date: Thu, 09 Jun 2011 16:43:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 8 (docbook/media)
References: <20110608161046.4ad95776.sfr@canb.auug.org.au> <20110608125243.e63a07fc.randy.dunlap@oracle.com> <4DF11E15.5030907@infradead.org>
In-Reply-To: <4DF11E15.5030907@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-06-2011 16:25, Mauro Carvalho Chehab escreveu:
> Em 08-06-2011 16:52, Randy Dunlap escreveu:
>> The DocBook/media/Makefile seems to be causing too much noise:
>>
>> ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.gif: No such file or directory
>> ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.png: No such file or directory
>>
>> Maybe the cleanmediadocs target could be made silent?
> 
> I'll take a look on it. 
> 
> FYI, The next build will probably be noisier, as it is now pointing to some 
> documentation gaps at the DVB API. Those gaps should take a longer time to fix, 
> as we need to discuss upstream about what should be done with those API's,
> that seems to be abandoned upstream (only one legacy DVB driver uses them).
> However, I was told that some out-of-tree drivers and some drivers under development
> are using them.
> 
> So, I intend to wait until the next merge window before either dropping those 
> legacy API specs (or moving them to a deprecated section) or to merge those
> out-of-tree drivers, with the proper documentation updates.
> 
>> also, where is the mediaindexdocs target defined?
> 
> Thanks for noticing it. We don't need this target anymore. I'll write a patch
> removing it.

This patch should remove the undesired noise.

commit 75125b9d44456e0cf2d1fbb72ae33c13415299d1
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Thu Jun 9 16:34:29 2011 -0300

    [media] DocBook: Don't be noisy at make cleanmediadocs
    
    While here, remove the mediaindexdocs from PHONY.
    
    Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 1e909c2..b7627e1 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -21,10 +21,10 @@ MEDIA_TEMP =  media-entities.tmpl \
 IMGFILES := $(addprefix $(MEDIA_OBJ_DIR)/media/, $(notdir $(shell ls $(MEDIA_SRC_DIR)/*/*.gif $(MEDIA_SRC_DIR)/*/*.png)))
 GENFILES := $(addprefix $(MEDIA_OBJ_DIR)/, $(MEDIA_TEMP))
 
-PHONY += cleanmediadocs mediaindexdocs
+PHONY += cleanmediadocs
 
 cleanmediadocs:
-	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(IMGFILES)
+	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(IMGFILES) 2>/dev/null
 
 $(obj)/media_api.xml: $(GENFILES) FORCE
 
