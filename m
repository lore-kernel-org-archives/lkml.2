Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0FLXKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 19:10:46 -0400
Received: from 213-189-27-130.reasonnet.com ([213.189.27.130]:60108 "EHLO
	theta.uwhosting.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0FLXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 19:10:44 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jun 2010 19:10:44 EDT
From: UndiFineD <k.dejong@undifined.nl>
To: k.dejong@undifined.nl, linux-kernel@vger.kernel.org
Subject: [PATCH] next-20100611 /usr
Date: Sun, 13 Jun 2010 00:42:21 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_O1AFMqF6b/oQWhv"
Message-Id: <201006130042.22030.k.dejong@undifined.nl>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - theta.uwhosting.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [26 6] / [26 6]
X-AntiAbuse: Sender Address Domain - undifined.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_O1AFMqF6b/oQWhv
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

next-20100611 /usr
janitor patch

signed-off-by: UndiFineD <k.dejong@undifined.nl>

--Boundary-00=_O1AFMqF6b/oQWhv
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0002-NEXT-20100611-usr.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-NEXT-20100611-usr.patch"

=46rom f0a14c155de5cf345c799dcb5abbe539c3bd4bfb Mon Sep 17 00:00:00 2001
Message-Id: <f0a14c155de5cf345c799dcb5abbe539c3bd4bfb.1276382091.git.k.dejo=
ng@undifined.nl>
=46rom: UndiFineD <k.dejong@undifined.nl>
Date: Sun, 13 Jun 2010 00:30:58 +0200
Subject: [PATCH] NEXT-20100611 /usr
 janitor patch

Signed-off-by: UndiFineD <k.dejong@undifined.nl>
=2D--
 usr/gen_init_cpio.c |  368 ++++++++++++++++++++++++++---------------------=
=2D---
 1 files changed, 186 insertions(+), 182 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index b2b3c2d..b0e45d7 100644
=2D-- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -37,7 +37,7 @@ static void push_string(const char *name)
 	offset +=3D name_len;
 }
=20
=2Dstatic void push_pad (void)
+static void push_pad(void)
 {
 	while (offset & 3) {
 		putchar(0);
@@ -74,21 +74,21 @@ static void cpio_trailer(void)
 	const char name[] =3D "TRAILER!!!";
=20
 	sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
=2D	       "%08X%08X%08X%08X%08X%08X%08X",
=2D		"070701",		/* magic */
=2D		0,			/* ino */
=2D		0,			/* mode */
=2D		(long) 0,		/* uid */
=2D		(long) 0,		/* gid */
=2D		1,			/* nlink */
=2D		(long) 0,		/* mtime */
=2D		0,			/* filesize */
=2D		0,			/* major */
=2D		0,			/* minor */
=2D		0,			/* rmajor */
=2D		0,			/* rminor */
=2D		(unsigned)strlen(name)+1, /* namesize */
=2D		0);			/* chksum */
+	    "%08X%08X%08X%08X%08X%08X%08X",
+	    "070701",		/* magic */
+	    0,			/* ino */
+	    0,			/* mode */
+	    (long) 0,		/* uid */
+	    (long) 0,		/* gid */
+	    1,			/* nlink */
+	    (long) 0,		/* mtime */
+	    0,			/* filesize */
+	    0,			/* major */
+	    0,			/* minor */
+	    0,			/* rmajor */
+	    0,			/* rminor */
+	    (unsigned)strlen(name)+1, /* namesize */
+	    0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
=20
@@ -98,28 +98,28 @@ static void cpio_trailer(void)
 	}
 }
=20
=2Dstatic int cpio_mkslink(const char *name, const char *target,
=2D			 unsigned int mode, uid_t uid, gid_t gid)
+static int cpio_mkslink(const char *name, const char *target, unsigned int=
 mode,
+    uid_t uid, gid_t gid)
 {
 	char s[256];
 	time_t mtime =3D time(NULL);
=20
=2D	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
=2D	       "%08X%08X%08X%08X%08X%08X%08X",
=2D		"070701",		/* magic */
=2D		ino++,			/* ino */
=2D		S_IFLNK | mode,		/* mode */
=2D		(long) uid,		/* uid */
=2D		(long) gid,		/* gid */
=2D		1,			/* nlink */
=2D		(long) mtime,		/* mtime */
=2D		(unsigned)strlen(target)+1, /* filesize */
=2D		3,			/* major */
=2D		1,			/* minor */
=2D		0,			/* rmajor */
=2D		0,			/* rminor */
=2D		(unsigned)strlen(name) + 1,/* namesize */
=2D		0);			/* chksum */
+	sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
+	    "%08X%08X%08X%08X%08X%08X%08X",
+	    "070701",		/* magic */
+	    ino++,		/* ino */
+	    S_IFLNK | mode,	/* mode */
+	    (long) uid,		/* uid */
+	    (long) gid,		/* gid */
+	    1,			/* nlink */
+	    (long) mtime,	/* mtime */
+	    (unsigned)strlen(target)+1, /* filesize */
+	    3,			/* major */
+	    1,			/* minor */
+	    0,			/* rmajor */
+	    0,			/* rminor */
+	    (unsigned)strlen(name) + 1, /* namesize */
+	    0);			/* chksum */
 	push_hdr(s);
 	push_string(name);
 	push_pad();
@@ -137,37 +137,38 @@ static int cpio_mkslink_line(const char *line)
 	int gid;
 	int rc =3D -1;
=20
=2D	if (5 !=3D sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX) "s %o %d =
%d", name, target, &mode, &uid, &gid)) {
+	if (5 !=3D sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX)
+	    "s %o %d %d", name, target, &mode, &uid, &gid)) {
 		fprintf(stderr, "Unrecognized dir format '%s'", line);
 		goto fail;
 	}
 	rc =3D cpio_mkslink(name, target, mode, uid, gid);
=2D fail:
+fail:
 	return rc;
 }
=20
=2Dstatic int cpio_mkgeneric(const char *name, unsigned int mode,
=2D		       uid_t uid, gid_t gid)
+static int cpio_mkgeneric(const char *name, unsigned int mode, uid_t uid,
+    gid_t gid)
 {
 	char s[256];
 	time_t mtime =3D time(NULL);
=20
=2D	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
=2D	       "%08X%08X%08X%08X%08X%08X%08X",
=2D		"070701",		/* magic */
=2D		ino++,			/* ino */
=2D		mode,			/* mode */
=2D		(long) uid,		/* uid */
=2D		(long) gid,		/* gid */
=2D		2,			/* nlink */
=2D		(long) mtime,		/* mtime */
=2D		0,			/* filesize */
=2D		3,			/* major */
=2D		1,			/* minor */
=2D		0,			/* rmajor */
=2D		0,			/* rminor */
=2D		(unsigned)strlen(name) + 1,/* namesize */
=2D		0);			/* chksum */
+	sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
+	    "%08X%08X%08X%08X%08X%08X%08X",
+	    "070701",		/* magic */
+	    ino++,		/* ino */
+	    mode,		/* mode */
+	    (long) uid,		/* uid */
+	    (long) gid,		/* gid */
+	    2,			/* nlink */
+	    (long) mtime,	/* mtime */
+	    0,			/* filesize */
+	    3,			/* major */
+	    1,			/* minor */
+	    0,			/* rmajor */
+	    0,			/* rminor */
+	    (unsigned)strlen(name) + 1,/* namesize */
+	    0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
 	return 0;
@@ -207,14 +208,15 @@ static int cpio_mkgeneric_line(const char *line, enum=
 generic_types gt)
 	int gid;
 	int rc =3D -1;
=20
=2D	if (4 !=3D sscanf(line, "%" str(PATH_MAX) "s %o %d %d", name, &mode, &u=
id, &gid)) {
=2D		fprintf(stderr, "Unrecognized %s format '%s'",
=2D			line, generic_type_table[gt].type);
+	if (4 !=3D sscanf(line, "%" str(PATH_MAX) "s %o %d %d", name, &mode, &uid,
+	    &gid)) {
+		fprintf(stderr, "Unrecognized %s format '%s'", line,
+		    generic_type_table[gt].type);
 		goto fail;
 	}
 	mode |=3D generic_type_table[gt].mode;
 	rc =3D cpio_mkgeneric(name, mode, uid, gid);
=2D fail:
+fail:
 	return rc;
 }
=20
@@ -233,9 +235,8 @@ static int cpio_mksock_line(const char *line)
 	return cpio_mkgeneric_line(line, GT_SOCK);
 }
=20
=2Dstatic int cpio_mknod(const char *name, unsigned int mode,
=2D		       uid_t uid, gid_t gid, char dev_type,
=2D		       unsigned int maj, unsigned int min)
+static int cpio_mknod(const char *name, unsigned int mode, uid_t uid, gid_=
t gid,
+    char dev_type, unsigned int maj, unsigned int min)
 {
 	char s[256];
 	time_t mtime =3D time(NULL);
@@ -245,22 +246,22 @@ static int cpio_mknod(const char *name, unsigned int =
mode,
 	else
 		mode |=3D S_IFCHR;
=20
=2D	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
=2D	       "%08X%08X%08X%08X%08X%08X%08X",
=2D		"070701",		/* magic */
=2D		ino++,			/* ino */
=2D		mode,			/* mode */
=2D		(long) uid,		/* uid */
=2D		(long) gid,		/* gid */
=2D		1,			/* nlink */
=2D		(long) mtime,		/* mtime */
=2D		0,			/* filesize */
=2D		3,			/* major */
=2D		1,			/* minor */
=2D		maj,			/* rmajor */
=2D		min,			/* rminor */
=2D		(unsigned)strlen(name) + 1,/* namesize */
=2D		0);			/* chksum */
+	sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
+	    "%08X%08X%08X%08X%08X%08X%08X",
+	    "070701",		/* magic */
+	    ino++,		/* ino */
+	    mode,		/* mode */
+	    (long) uid,		/* uid */
+	    (long) gid,		/* gid */
+	    1,			/* nlink */
+	    (long) mtime,	/* mtime */
+	    0,			/* filesize */
+	    3,			/* major */
+	    1,			/* minor */
+	    maj,		/* rmajor */
+	    min,		/* rminor */
+	    (unsigned)strlen(name) + 1,/* namesize */
+	    0);			/* chksum */
 	push_hdr(s);
 	push_rest(name);
 	return 0;
@@ -277,19 +278,18 @@ static int cpio_mknod_line(const char *line)
 	unsigned int min;
 	int rc =3D -1;
=20
=2D	if (7 !=3D sscanf(line, "%" str(PATH_MAX) "s %o %d %d %c %u %u",
=2D			 name, &mode, &uid, &gid, &dev_type, &maj, &min)) {
+	if (7 !=3D sscanf(line, "%" str(PATH_MAX) "s %o %d %d %c %u %u", name,
+	    &mode, &uid, &gid, &dev_type, &maj, &min)) {
 		fprintf(stderr, "Unrecognized nod format '%s'", line);
 		goto fail;
 	}
 	rc =3D cpio_mknod(name, mode, uid, gid, dev_type, maj, min);
=2D fail:
+fail:
 	return rc;
 }
=20
 static int cpio_mkfile(const char *name, const char *location,
=2D			unsigned int mode, uid_t uid, gid_t gid,
=2D			unsigned int nlinks)
+    unsigned int mode, uid_t uid, gid_t gid, unsigned int nlinks)
 {
 	char s[256];
 	char *filebuf =3D NULL;
@@ -303,52 +303,54 @@ static int cpio_mkfile(const char *name, const char *=
location,
=20
 	mode |=3D S_IFREG;
=20
=2D	retval =3D stat (location, &buf);
+	retval =3D stat(location, &buf);
 	if (retval) {
=2D		fprintf (stderr, "File %s could not be located\n", location);
+		fprintf(stderr, "File %s could not be located\n", location);
 		goto error;
 	}
=20
=2D	file =3D open (location, O_RDONLY);
+	file =3D open(location, O_RDONLY);
 	if (file < 0) {
=2D		fprintf (stderr, "File %s could not be opened for reading\n", location=
);
+		fprintf(stderr, "File %s could not be opened for reading\n",
+		    location);
 		goto error;
 	}
=20
 	filebuf =3D malloc(buf.st_size);
 	if (!filebuf) {
=2D		fprintf (stderr, "out of memory\n");
+		fprintf(stderr, "out of memory\n");
 		goto error;
 	}
=20
=2D	retval =3D read (file, filebuf, buf.st_size);
+	retval =3D read(file, filebuf, buf.st_size);
 	if (retval < 0) {
=2D		fprintf (stderr, "Can not read %s file\n", location);
+		fprintf(stderr, "Can not read %s file\n", location);
 		goto error;
 	}
=20
 	size =3D 0;
 	for (i =3D 1; i <=3D nlinks; i++) {
 		/* data goes on last link */
=2D		if (i =3D=3D nlinks) size =3D buf.st_size;
+		if (i =3D=3D nlinks)
+			size =3D buf.st_size;
=20
 		namesize =3D strlen(name) + 1;
=2D		sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
=2D		       "%08lX%08X%08X%08X%08X%08X%08X",
=2D			"070701",		/* magic */
=2D			ino,			/* ino */
=2D			mode,			/* mode */
=2D			(long) uid,		/* uid */
=2D			(long) gid,		/* gid */
=2D			nlinks,			/* nlink */
=2D			(long) buf.st_mtime,	/* mtime */
=2D			size,			/* filesize */
=2D			3,			/* major */
=2D			1,			/* minor */
=2D			0,			/* rmajor */
=2D			0,			/* rminor */
=2D			namesize,		/* namesize */
=2D			0);			/* chksum */
+		sprintf(s, "%s%08X%08X%08lX%08lX%08X%08lX"
+		    "%08lX%08X%08X%08X%08X%08X%08X",
+		    "070701",		/* magic */
+		    ino,		/* ino */
+		    mode,		/* mode */
+		    (long) uid,		/* uid */
+		    (long) gid,		/* gid */
+		    nlinks,		/* nlink */
+		    (long) buf.st_mtime,/* mtime */
+		    size,		/* filesize */
+		    3,			/* major */
+		    1,			/* minor */
+		    0,			/* rmajor */
+		    0,			/* rminor */
+		    namesize,		/* namesize */
+		    0);			/* chksum */
 		push_hdr(s);
 		push_string(name);
 		push_pad();
@@ -361,42 +363,40 @@ static int cpio_mkfile(const char *name, const char *=
location,
 			offset +=3D size;
 			push_pad();
 		}
=2D
 		name +=3D namesize;
 	}
 	ino++;
 	rc =3D 0;
=2D=09
 error:
=2D	if (filebuf) free(filebuf);
=2D	if (file >=3D 0) close(file);
+	if (filebuf)
+		free(filebuf);
+	if (file >=3D 0)
+		close(file);
 	return rc;
 }
=20
 static char *cpio_replace_env(char *new_location)
 {
=2D       char expanded[PATH_MAX + 1];
=2D       char env_var[PATH_MAX + 1];
=2D       char *start;
=2D       char *end;
=2D
=2D       for (start =3D NULL; (start =3D strstr(new_location, "${")); ) {
=2D               end =3D strchr(start, '}');
=2D               if (start < end) {
=2D                       *env_var =3D *expanded =3D '\0';
=2D                       strncat(env_var, start + 2, end - start - 2);
=2D                       strncat(expanded, new_location, start - new_locat=
ion);
=2D                       strncat(expanded, getenv(env_var), PATH_MAX);
=2D                       strncat(expanded, end + 1, PATH_MAX);
=2D                       strncpy(new_location, expanded, PATH_MAX);
=2D               } else
=2D                       break;
=2D       }
=2D
=2D       return new_location;
+	char expanded[PATH_MAX + 1];
+	char env_var[PATH_MAX + 1];
+	char *start;
+	char *end;
+
+	for (start =3D NULL; (start =3D strstr(new_location, "${")); ) {
+		end =3D strchr(start, '}');
+		if (start < end) {
+			*env_var =3D *expanded =3D '\0';
+			strncat(env_var, start + 2, end - start - 2);
+			strncat(expanded, new_location, start - new_location);
+			strncat(expanded, getenv(env_var), PATH_MAX);
+			strncat(expanded, end + 1, PATH_MAX);
+			strncpy(new_location, expanded, PATH_MAX);
+		} else
+			break;
+	}
+	return new_location;
 }
=20
=2D
 static int cpio_mkfile_line(const char *line)
 {
 	char name[PATH_MAX + 1];
@@ -410,8 +410,7 @@ static int cpio_mkfile_line(const char *line)
 	int rc =3D -1;
=20
 	if (5 > sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX)
=2D				"s %o %d %d %n",
=2D				name, location, &mode, &uid, &gid, &end)) {
+	    "s %o %d %d %n", name, location, &mode, &uid, &gid, &end)) {
 		fprintf(stderr, "Unrecognized file format '%s'", line);
 		goto fail;
 	}
@@ -421,7 +420,7 @@ static int cpio_mkfile_line(const char *line)
=20
 		dname =3D malloc(strlen(line));
 		if (!dname) {
=2D			fprintf (stderr, "out of memory (%d)\n", dname_len);
+			fprintf(stderr, "out of memory (%d)\n", dname_len);
 			goto fail;
 		}
=20
@@ -431,7 +430,7 @@ static int cpio_mkfile_line(const char *line)
 		do {
 			nend =3D 0;
 			if (sscanf(line + end, "%" str(PATH_MAX) "s %n",
=2D					name, &nend) < 1)
+			    name, &nend) < 1)
 				break;
 			len =3D strlen(name) + 1;
 			memcpy(dname + dname_len, name, len);
@@ -442,49 +441,50 @@ static int cpio_mkfile_line(const char *line)
 	} else {
 		dname =3D name;
 	}
=2D	rc =3D cpio_mkfile(dname, cpio_replace_env(location),
=2D	                 mode, uid, gid, nlinks);
=2D fail:
=2D	if (dname_len) free(dname);
+	rc =3D cpio_mkfile(dname, cpio_replace_env(location), mode, uid, gid,
+	     nlinks);
+fail:
+	if (dname_len)
+		free(dname);
 	return rc;
 }
=20
 static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
=2D		"\t%s <cpio_list>\n"
=2D		"\n"
=2D		"<cpio_list> is a file containing newline separated entries that\n"
=2D		"describe the files to be included in the initramfs archive:\n"
=2D		"\n"
=2D		"# a comment\n"
=2D		"file <name> <location> <mode> <uid> <gid> [<hard links>]\n"
=2D		"dir <name> <mode> <uid> <gid>\n"
=2D		"nod <name> <mode> <uid> <gid> <dev_type> <maj> <min>\n"
=2D		"slink <name> <target> <mode> <uid> <gid>\n"
=2D		"pipe <name> <mode> <uid> <gid>\n"
=2D		"sock <name> <mode> <uid> <gid>\n"
=2D		"\n"
=2D		"<name>       name of the file/dir/nod/etc in the archive\n"
=2D		"<location>   location of the file in the current filesystem\n"
=2D		"             expands shell variables quoted with ${}\n"
=2D		"<target>     link target\n"
=2D		"<mode>       mode/permissions of the file\n"
=2D		"<uid>        user id (0=3Droot)\n"
=2D		"<gid>        group id (0=3Droot)\n"
=2D		"<dev_type>   device type (b=3Dblock, c=3Dcharacter)\n"
=2D		"<maj>        major number of nod\n"
=2D		"<min>        minor number of nod\n"
=2D		"<hard links> space separated list of other links to file\n"
=2D		"\n"
=2D		"example:\n"
=2D		"# A simple initramfs\n"
=2D		"dir /dev 0755 0 0\n"
=2D		"nod /dev/console 0600 0 0 c 5 1\n"
=2D		"dir /root 0700 0 0\n"
=2D		"dir /sbin 0755 0 0\n"
=2D		"file /sbin/kinit /usr/src/klibc/kinit/kinit 0755 0 0\n",
=2D		prog);
+	    "\t%s <cpio_list>\n"
+	    "\n"
+	    "<cpio_list> is a file containing newline separated entries that\n"
+	    "describe the files to be included in the initramfs archive:\n"
+	    "\n"
+	    "# a comment\n"
+	    "file <name> <location> <mode> <uid> <gid> [<hard links>]\n"
+	    "dir <name> <mode> <uid> <gid>\n"
+	    "nod <name> <mode> <uid> <gid> <dev_type> <maj> <min>\n"
+	    "slink <name> <target> <mode> <uid> <gid>\n"
+	    "pipe <name> <mode> <uid> <gid>\n"
+	    "sock <name> <mode> <uid> <gid>\n"
+	    "\n"
+	    "<name>       name of the file/dir/nod/etc in the archive\n"
+	    "<location>   location of the file in the current filesystem\n"
+	    "             expands shell variables quoted with ${}\n"
+	    "<target>     link target\n"
+	    "<mode>       mode/permissions of the file\n"
+	    "<uid>        user id (0=3Droot)\n"
+	    "<gid>        group id (0=3Droot)\n"
+	    "<dev_type>   device type (b=3Dblock, c=3Dcharacter)\n"
+	    "<maj>        major number of nod\n"
+	    "<min>        minor number of nod\n"
+	    "<hard links> space separated list of other links to file\n"
+	    "\n"
+	    "example:\n"
+	    "# A simple initramfs\n"
+	    "dir /dev 0755 0 0\n"
+	    "nod /dev/console 0600 0 0 c 5 1\n"
+	    "dir /root 0700 0 0\n"
+	    "dir /sbin 0755 0 0\n"
+	    "file /sbin/kinit /usr/src/klibc/kinit/kinit 0755 0 0\n",
+	    prog);
 }
=20
 struct file_handler file_handler_table[] =3D {
@@ -514,7 +514,7 @@ struct file_handler file_handler_table[] =3D {
=20
 #define LINE_SIZE (2 * PATH_MAX + 50)
=20
=2Dint main (int argc, char *argv[])
+int main(int argc, char *argv[])
 {
 	FILE *cpio_list;
 	char line[LINE_SIZE];
@@ -529,9 +529,10 @@ int main (int argc, char *argv[])
=20
 	if (!strcmp(argv[1], "-"))
 		cpio_list =3D stdin;
=2D	else if (! (cpio_list =3D fopen(argv[1], "r"))) {
+	else if (!(fopen(argv[1], "r"))) {
+		cpio_list =3D fopen(argv[1], "r");
 		fprintf(stderr, "ERROR: unable to open '%s': %s\n\n",
=2D			argv[1], strerror(errno));
+		    argv[1], strerror(errno));
 		usage(argv[0]);
 		exit(1);
 	}
@@ -547,10 +548,11 @@ int main (int argc, char *argv[])
 			continue;
 		}
=20
=2D		if (! (type =3D strtok(line, " \t"))) {
+		if (!(strtok(line, " \t"))) {
+			type =3D strtok(line, " \t");
 			fprintf(stderr,
=2D				"ERROR: incorrect format, could not locate file type line %d: '%s'\n=
",
=2D				line_nr, line);
+			    "ERROR: incorrect format, could not locate file type line %d: '%s'\=
n",
+			    line_nr, line);
 			ec =3D -1;
 			break;
 		}
@@ -565,17 +567,19 @@ int main (int argc, char *argv[])
 			continue;
 		}
=20
=2D		if (! (args =3D strtok(NULL, "\n"))) {
+		if (!(strtok(NULL, "\n"))) {
+			args =3D strtok(NULL, "\n");
 			fprintf(stderr,
=2D				"ERROR: incorrect format, newline required line %d: '%s'\n",
=2D				line_nr, line);
+			    "ERROR: incorrect format, newline required line %d: '%s'\n",
+			    line_nr, line);
 			ec =3D -1;
 		}
=20
 		for (type_idx =3D 0; file_handler_table[type_idx].type; type_idx++) {
 			int rc;
=2D			if (! strcmp(line, file_handler_table[type_idx].type)) {
=2D				if ((rc =3D file_handler_table[type_idx].handler(args))) {
+			if (!strcmp(line, file_handler_table[type_idx].type)) {
+				if (file_handler_table[type_idx].handler(args)) {
+					rc =3D file_handler_table[type_idx].handler(args);
 					ec =3D rc;
 					fprintf(stderr, " line %d\n", line_nr);
 				}
=2D-=20
1.7.0.4


--Boundary-00=_O1AFMqF6b/oQWhv--
