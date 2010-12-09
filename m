Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0LIHbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:31:34 -0500
Received: from nm2-vm0.bullet.mail.in.yahoo.com ([121.101.151.210]:38528 "HELO
	nm2-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751043Ab0LIHbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:31:33 -0500
X-Yahoo-Newman-Id: 931609.65708.bm@omp1004.mail.in.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=tfeexPrfX/QVTIlhKj6LSdncN/TMvLfrsXqfp/KtuylnQLWw36pBQBSH8Iix6Rx6ZB4AFVaXME0KfjKilO8icUM5SgSqHRJb3W/ayrjPcd8brvejoSE7pTbgOyCcR2y8q7c25TmpL/01q+SWk3q3wo/+s40GOu4V0qeONxx/Z/w=  ;
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
X-YMail-OSG: u7eO_HAVM1nejlOlr.iEYoVmYwTSdxZZVH4PRTCII6bW8Oo
 TDvOiND3OvNaiJ9LK7kLgfpVAt7zHRSLJvHjroQkN1BgvsSSvtb61uDH3nWh
 JMQPzsu1Hvhtxi4HYwhZXrH6P75YsD3.x3wGGJdqcAVIKSpduwvBpSpVbWCW
 rwAl1Xiu_4E0sfXzbcDb3_t7ePcJ3yYw8m2hYMSSpfgNCGx4VNE2OgECMRwr
 x3IHroepXz34vwohxH0kbRO_vsgnXD2Kvb8Cx2NmlMS3OebXpf9IUqE2l8QE
 x6MFq3A.RIjTTEA--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 9 Dec 2010 13:01:26 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: linux-kernel@vger.kernel.org
Subject: format and standards issues fixes
Message-ID: <20101209073126.GA2212@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello.

I have fixed several issues with checkpatch.pl
fixes include standards and format issues.

i have attached the patch along with this mail.
-- 
software engineer.
department of computer science
rajagiri school of engineering and technology.

--TB36FDmn/VVEgNH/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-sound-Fixed-format-and-standard-issues-in-sound-soun.patch"

>From aaee9f17191f9960cf40f2a09d88346b26b12ff8 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Wed, 8 Dec 2010 22:57:45 +0530
Subject: [PATCH 2/2] sound : Fixed format and standard issues in sound/sound_core.c
 This is a patch to the sound/sound_core.c file that fixes format
 and standards  issue found by the checkpatch.pl tool.
 Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

---
 sound/sound_core.c |  157 +++++++++++++++++++++++++---------------------------
 1 files changed, 76 insertions(+), 81 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 5580ace..9ce2e87 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -68,7 +68,7 @@ module_exit(cleanup_soundcore);
 #ifdef CONFIG_SOUND_OSS_CORE
 /*
  *	OSS sound core handling. Breaks out sound functions to submodules
- *	
+ *
  *	Author:		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Fixes:
@@ -80,9 +80,9 @@ module_exit(cleanup_soundcore);
  *	2 of the License, or (at your option) any later version.
  *
  *                         --------------------
- * 
+ *
  *	Top level handler for the sound subsystem. Various devices can
- *	plug into this. The fact they don't all go via OSS doesn't mean 
+ *      plug into this. The fact they don't all go via OSS doesn't mean
  *	they don't have to implement the OSS API. There is a lot of logic
  *	to keeping much of the OSS weight out of the code in a compatibility
  *	module, but it's up to the driver to rember to load it...
@@ -111,8 +111,7 @@ module_exit(cleanup_soundcore);
 
 #define SOUND_STEP 16
 
-struct sound_unit
-{
+struct sound_unit {
 	int unit_minor;
 	const struct file_operations *unit_fops;
 	struct sound_unit *next;
@@ -152,15 +151,14 @@ extern int msnd_pinnacle_init(void);
 #ifdef CONFIG_SOUND_OSS_CORE_PRECLAIM
 static int preclaim_oss = 1;
 #else
-static int preclaim_oss = 0;
+static int preclaim_oss = -1;
 #endif
 
 module_param(preclaim_oss, int, 0444);
 
 static int soundcore_open(struct inode *, struct file *);
 
-static const struct file_operations soundcore_fops =
-{
+static const struct file_operations soundcore_fops = {
 	/* We must have an owner or the module locking fails */
 	.owner	= THIS_MODULE,
 	.open	= soundcore_open,
@@ -172,70 +170,68 @@ static const struct file_operations soundcore_fops =
  *	join into it. Called with the lock asserted
  */
 
-static int __sound_insert_unit(struct sound_unit * s, struct sound_unit **list, const struct file_operations *fops, int index, int low, int top)
+static int __sound_insert_unit(struct sound_unit *s, struct sound_unit **list,\
+const struct file_operations *fops, int index, int low, int top)
 {
-	int n=low;
+	int n = low;
 
 	if (index < 0) {	/* first free */
 
-		while (*list && (*list)->unit_minor<n)
-			list=&((*list)->next);
+		while (*list && (*list)->unit_minor < n)
+			list = &((*list)->next);
 
-		while(n<top)
-		{
+		while (n < top) {
 			/* Found a hole ? */
-			if(*list==NULL || (*list)->unit_minor>n)
+			if (*list == NULL || (*list)->unit_minor > n)
 				break;
-			list=&((*list)->next);
-			n+=SOUND_STEP;
+			list = &((*list)->next);
+			n += SOUND_STEP;
 		}
 
-		if(n>=top)
+		if (n >= top)
 			return -ENOENT;
 	} else {
 		n = low+(index*16);
 		while (*list) {
-			if ((*list)->unit_minor==n)
+			if ((*list)->unit_minor == n)
 				return -EBUSY;
-			if ((*list)->unit_minor>n)
+			if ((*list)->unit_minor > n)
 				break;
-			list=&((*list)->next);
+			list = &((*list)->next);
 		}
-	}	
-		
+	}
+
 	/*
 	 *	Fill it in
 	 */
-	 
-	s->unit_minor=n;
-	s->unit_fops=fops;
-	
+
+	s->unit_minor = n;
+	s->unit_fops = fops;
+
 	/*
 	 *	Link it
 	 */
-	 
-	s->next=*list;
-	*list=s;
-	
-	
+
+	s->next = *list;
+	*list = s;
+
+
 	return n;
 }
 
 /*
  *	Remove a node from the chain. Called with the lock asserted
  */
- 
-static struct sound_unit *__sound_remove_unit(struct sound_unit **list, int unit)
-{
-	while(*list)
-	{
-		struct sound_unit *p=*list;
-		if(p->unit_minor==unit)
-		{
-			*list=p->next;
+
+static struct sound_unit *__sound_remove_unit(struct \
+sound_unit **list, int unit) {
+	while (*list) {
+		struct sound_unit *p = *list;
+		if (p->unit_minor == unit) {
+			*list = p->next;
 			return p;
 		}
-		list=&(p->next);
+		list = &(p->next);
 	}
 	printk(KERN_ERR "Sound device %d went missing!\n", unit);
 	return NULL;
@@ -252,8 +248,9 @@ static DEFINE_SPINLOCK(sound_loader_lock);
  *	list. Acquires locks as needed
  */
 
-static int sound_insert_unit(struct sound_unit **list, const struct file_operations *fops, int index, int low, int top, const char *name, umode_t mode, struct device *dev)
-{
+static int sound_insert_unit(struct sound_unit **list, const struct \
+file_operations *fops, int index, int low, int top, const char *name,\
+umode_t mode, struct device *dev) {
 	struct sound_unit *s = kmalloc(sizeof(*s), GFP_KERNEL);
 	int r;
 
@@ -264,7 +261,7 @@ static int sound_insert_unit(struct sound_unit **list, const struct file_operati
 retry:
 	r = __sound_insert_unit(s, list, fops, index, low, top);
 	spin_unlock(&sound_loader_lock);
-	
+
 	if (r < 0)
 		goto fail;
 	else if (r < SOUND_STEP)
@@ -306,7 +303,7 @@ fail:
  *	completed the removal before their file operations become
  *	invalid.
  */
- 	
+
 static void sound_remove_unit(struct sound_unit **list, int unit)
 {
 	struct sound_unit *p;
@@ -356,7 +353,7 @@ static struct sound_unit *chains[SOUND_STEP];
  *	subsystem. The allocated number is returned on success. On failure
  *	a negative error code is returned.
  */
- 
+
 int register_sound_special_device(const struct file_operations *fops, int unit,
 				  struct device *dev)
 {
@@ -366,59 +363,59 @@ int register_sound_special_device(const struct file_operations *fops, int unit,
 	char _name[16];
 
 	switch (chain) {
-	    case 0:
+	case 0:
 		name = "mixer";
 		break;
-	    case 1:
+	case 1:
 		name = "sequencer";
 		if (unit >= SOUND_STEP)
 			goto __unknown;
 		max_unit = unit + 1;
 		break;
-	    case 2:
+	case 2:
 		name = "midi";
 		break;
-	    case 3:
+	case 3:
 		name = "dsp";
 		break;
-	    case 4:
+	case 4:
 		name = "audio";
 		break;
-	    case 8:
+	case 8:
 		name = "sequencer2";
 		if (unit >= SOUND_STEP)
 			goto __unknown;
 		max_unit = unit + 1;
 		break;
-	    case 9:
+	case 9:
 		name = "dmmidi";
 		break;
-	    case 10:
+	case 10:
 		name = "dmfm";
 		break;
-	    case 12:
+	case 12:
 		name = "adsp";
 		break;
-	    case 13:
+	case 13:
 		name = "amidi";
 		break;
-	    case 14:
+	case 14:
 		name = "admmidi";
 		break;
-	    default:
-	    	{
-		    __unknown:
+	default:
+		{
+__unknown:
 			sprintf(_name, "unknown%d", chain);
-		    	if (unit >= SOUND_STEP)
-		    		strcat(_name, "-");
-		    	name = _name;
+			if (unit >= SOUND_STEP)
+				strcat(_name, "-");
+				name = _name;
 		}
 		break;
 	}
 	return sound_insert_unit(&chains[chain], fops, -1, unit, max_unit,
 				 name, S_IRUSR | S_IWUSR, dev);
 }
- 
+
 EXPORT_SYMBOL(register_sound_special_device);
 
 int register_sound_special(const struct file_operations *fops, int unit)
@@ -468,7 +465,7 @@ EXPORT_SYMBOL(register_sound_midi);
  *	DSP's are registered as a triple. Register only one and cheat
  *	in open - see below.
  */
- 
+
 /**
  *	register_sound_dsp - register a DSP device
  *	@fops: File operations for the driver
@@ -504,7 +501,7 @@ void unregister_sound_special(int unit)
 {
 	sound_remove_unit(&chains[unit % SOUND_STEP], unit);
 }
- 
+
 EXPORT_SYMBOL(unregister_sound_special);
 
 /**
@@ -558,13 +555,12 @@ EXPORT_SYMBOL(unregister_sound_dsp);
 static struct sound_unit *__look_for_unit(int chain, int unit)
 {
 	struct sound_unit *s;
-	
-	s=chains[chain];
-	while(s && s->unit_minor <= unit)
-	{
-		if(s->unit_minor==unit)
+
+	s = chains[chain];
+	while (s && s->unit_minor <= unit) {
+		if (s->unit_minor == unit)
 			return s;
-		s=s->next;
+		s = s->next;
 	}
 	return NULL;
 }
@@ -576,14 +572,13 @@ static int soundcore_open(struct inode *inode, struct file *file)
 	struct sound_unit *s;
 	const struct file_operations *new_fops = NULL;
 
-	chain=unit&0x0F;
-	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
-	{
-		unit&=0xF0;
-		unit|=3;
-		chain=3;
+	chain = unit&0x0F;
+	if (chain == 4 || chain == 5)	/* dsp/audio/dsp16 */ {
+		unit &= 0xF0;
+		unit |= 3;
+		chain = 3;
 	}
-	
+
 	spin_lock(&sound_loader_lock);
 	s = __look_for_unit(chain, unit);
 	if (s)
@@ -630,7 +625,7 @@ static int soundcore_open(struct inode *inode, struct file *file)
 		spin_unlock(&sound_loader_lock);
 
 		if (file->f_op->open)
-			err = file->f_op->open(inode,file);
+			err = file->f_op->open(inode, file);
 
 		if (err) {
 			fops_put(file->f_op);
-- 
1.7.1


--TB36FDmn/VVEgNH/--
