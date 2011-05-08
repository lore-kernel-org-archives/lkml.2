Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab1EHSxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:53:04 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:52421 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1EHSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:50:19 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 May 2011 14:50:18 EDT
Date: Sun, 8 May 2011 20:43:34 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/14] HPFS: Use types with defined width
Message-ID: <alpine.DEB.2.00.1105082026510.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use types with defined width

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/hpfs.h |  219 +++++++++++++++++++++++++++------------------------------
 1 file changed, 107 insertions(+), 112 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs.h	2011-05-05 01:01:54.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs.h	2011-05-05 01:02:51.000000000 +0200
@@ -21,7 +21,7 @@
 
 /* Notation */
 
-typedef unsigned secno;			/* sector number, partition relative */
+typedef u32 secno;			/* sector number, partition relative */
 
 typedef secno dnode_secno;		/* sector number of a dnode */
 typedef secno fnode_secno;		/* sector number of an fnode */
@@ -38,28 +38,28 @@ typedef u32 time32_t;		/* 32-bit time_t 
 
 struct hpfs_boot_block
 {
-  unsigned char jmp[3];
-  unsigned char oem_id[8];
-  unsigned char bytes_per_sector[2];	/* 512 */
-  unsigned char sectors_per_cluster;
-  unsigned char n_reserved_sectors[2];
-  unsigned char n_fats;
-  unsigned char n_rootdir_entries[2];
-  unsigned char n_sectors_s[2];
-  unsigned char media_byte;
-  unsigned short sectors_per_fat;
-  unsigned short sectors_per_track;
-  unsigned short heads_per_cyl;
-  unsigned int n_hidden_sectors;
-  unsigned int n_sectors_l;		/* size of partition */
-  unsigned char drive_number;
-  unsigned char mbz;
-  unsigned char sig_28h;		/* 28h */
-  unsigned char vol_serno[4];
-  unsigned char vol_label[11];
-  unsigned char sig_hpfs[8];		/* "HPFS    " */
-  unsigned char pad[448];
-  unsigned short magic;			/* aa55 */
+  u8 jmp[3];
+  u8 oem_id[8];
+  u8 bytes_per_sector[2];	/* 512 */
+  u8 sectors_per_cluster;
+  u8 n_reserved_sectors[2];
+  u8 n_fats;
+  u8 n_rootdir_entries[2];
+  u8 n_sectors_s[2];
+  u8 media_byte;
+  u16 sectors_per_fat;
+  u16 sectors_per_track;
+  u16 heads_per_cyl;
+  u32 n_hidden_sectors;
+  u32 n_sectors_l;		/* size of partition */
+  u8 drive_number;
+  u8 mbz;
+  u8 sig_28h;			/* 28h */
+  u8 vol_serno[4];
+  u8 vol_label[11];
+  u8 sig_hpfs[8];		/* "HPFS    " */
+  u8 pad[448];
+  u16 magic;			/* aa55 */
 };
 
 
@@ -71,31 +71,30 @@ struct hpfs_boot_block
 
 struct hpfs_super_block
 {
-  unsigned magic;			/* f995 e849 */
-  unsigned magic1;			/* fa53 e9c5, more magic? */
-  /*unsigned huh202;*/			/* ?? 202 = N. of B. in 1.00390625 S.*/
-  char version;				/* version of a filesystem  usually 2 */
-  char funcversion;			/* functional version - oldest version
+  u32 magic;				/* f995 e849 */
+  u32 magic1;				/* fa53 e9c5, more magic? */
+  u8 version;				/* version of a filesystem  usually 2 */
+  u8 funcversion;			/* functional version - oldest version
   					   of filesystem that can understand
 					   this disk */
-  unsigned short int zero;		/* 0 */
+  u16 zero;				/* 0 */
   fnode_secno root;			/* fnode of root directory */
   secno n_sectors;			/* size of filesystem */
-  unsigned n_badblocks;			/* number of bad blocks */
+  u32 n_badblocks;			/* number of bad blocks */
   secno bitmaps;			/* pointers to free space bit maps */
-  unsigned zero1;			/* 0 */
+  u32 zero1;				/* 0 */
   secno badblocks;			/* bad block list */
-  unsigned zero3;			/* 0 */
+  u32 zero3;				/* 0 */
   time32_t last_chkdsk;			/* date last checked, 0 if never */
-  /*unsigned zero4;*/			/* 0 */
-  time32_t last_optimize;			/* date last optimized, 0 if never */
+  /*u32 zero4;*/			/* 0 */
+  time32_t last_optimize;		/* date last optimized, 0 if never */
   secno n_dir_band;			/* number of sectors in dir band */
   secno dir_band_start;			/* first sector in dir band */
   secno dir_band_end;			/* last sector in dir band */
   secno dir_band_bitmap;		/* free space map, 1 dnode per bit */
-  char volume_name[32];			/* not used */
+  u8 volume_name[32];			/* not used */
   secno user_id_table;			/* 8 preallocated sectors - user id */
-  unsigned zero6[103];			/* 0 */
+  u32 zero6[103];			/* 0 */
 };
 
 
@@ -107,11 +106,10 @@ struct hpfs_super_block
 
 struct hpfs_spare_block
 {
-  unsigned magic;			/* f991 1849 */
-  unsigned magic1;			/* fa52 29c5, more magic? */
+  u32 magic;				/* f991 1849 */
+  u32 magic1;				/* fa52 29c5, more magic? */
 
   unsigned dirty: 1;			/* 0 clean, 1 "improperly stopped" */
-  /*unsigned flag1234: 4;*/		/* unknown flags */
   unsigned sparedir_used: 1;		/* spare dirblks used */
   unsigned hotfixes_used: 1;		/* hotfixes used */
   unsigned bad_sector: 1;		/* bad sector, corrupted disk (???) */
@@ -126,25 +124,24 @@ struct hpfs_spare_block
   unsigned dce_acls_active: 1;
   unsigned dasd_limits_dirty: 1;
   unsigned flag67: 2;
-  unsigned char mm_contlgulty;
-  unsigned char unused;
+  u8 mm_contlgulty;
+  u8 unused;
 
   secno hotfix_map;			/* info about remapped bad sectors */
-  unsigned n_spares_used;		/* number of hotfixes */
-  unsigned n_spares;			/* number of spares in hotfix map */
-  unsigned n_dnode_spares_free;		/* spare dnodes unused */
-  unsigned n_dnode_spares;		/* length of spare_dnodes[] list,
+  u32 n_spares_used;			/* number of hotfixes */
+  u32 n_spares;				/* number of spares in hotfix map */
+  u32 n_dnode_spares_free;		/* spare dnodes unused */
+  u32 n_dnode_spares;			/* length of spare_dnodes[] list,
 					   follows in this block*/
   secno code_page_dir;			/* code page directory block */
-  unsigned n_code_pages;		/* number of code pages */
-  /*unsigned large_numbers[2];*/	/* ?? */
-  unsigned super_crc;			/* on HPFS386 and LAN Server this is
+  u32 n_code_pages;			/* number of code pages */
+  u32 super_crc;			/* on HPFS386 and LAN Server this is
   					   checksum of superblock, on normal
 					   OS/2 unused */
-  unsigned spare_crc;			/* on HPFS386 checksum of spareblock */
-  unsigned zero1[15];			/* unused */
+  u32 spare_crc;			/* on HPFS386 checksum of spareblock */
+  u32 zero1[15];			/* unused */
   dnode_secno spare_dnodes[100];	/* emergency free dnode list */
-  unsigned zero2[1];			/* room for more? */
+  u32 zero2[1];				/* room for more? */
 };
 
 /* The bad block list is 4 sectors long.  The first word must be zero,
@@ -179,18 +176,18 @@ struct hpfs_spare_block
 
 struct code_page_directory
 {
-  unsigned magic;			/* 4945 21f7 */
-  unsigned n_code_pages;		/* number of pointers following */
-  unsigned zero1[2];
+  u32 magic;				/* 4945 21f7 */
+  u32 n_code_pages;			/* number of pointers following */
+  u32 zero1[2];
   struct {
-    unsigned short ix;			/* index */
-    unsigned short code_page_number;	/* code page number */
-    unsigned bounds;			/* matches corresponding word
+    u16 ix;				/* index */
+    u16 code_page_number;		/* code page number */
+    u32 bounds;				/* matches corresponding word
 					   in data block */
     secno code_page_data;		/* sector number of a code_page_data
 					   containing c.p. array */
-    unsigned short index;		/* index in c.p. array in that sector*/
-    unsigned short unknown;		/* some unknown value; usually 0;
+    u16 index;				/* index in c.p. array in that sector*/
+    u16 unknown;			/* some unknown value; usually 0;
     					   2 in Japanese version */
   } array[31];				/* unknown length */
 };
@@ -201,21 +198,21 @@ struct code_page_directory
 
 struct code_page_data
 {
-  unsigned magic;			/* 8945 21f7 */
-  unsigned n_used;			/* # elements used in c_p_data[] */
-  unsigned bounds[3];			/* looks a bit like
+  u32 magic;				/* 8945 21f7 */
+  u32 n_used;				/* # elements used in c_p_data[] */
+  u32 bounds[3];			/* looks a bit like
 					     (beg1,end1), (beg2,end2)
 					   one byte each */
-  unsigned short offs[3];		/* offsets from start of sector
+  u16 offs[3];				/* offsets from start of sector
 					   to start of c_p_data[ix] */
   struct {
-    unsigned short ix;			/* index */
-    unsigned short code_page_number;	/* code page number */
-    unsigned short unknown;		/* the same as in cp directory */
-    unsigned char map[128];		/* upcase table for chars 80..ff */
-    unsigned short zero2;
+    u16 ix;				/* index */
+    u16 code_page_number;		/* code page number */
+    u16 unknown;			/* the same as in cp directory */
+    u8 map[128];			/* upcase table for chars 80..ff */
+    u16 zero2;
   } code_page[3];
-  unsigned char incognita[78];
+  u8 incognita[78];
 };
 
 
@@ -255,8 +252,8 @@ struct code_page_data
 #define DNODE_MAGIC   0x77e40aae
 
 struct dnode {
-  unsigned magic;			/* 77e4 0aae */
-  unsigned first_free;			/* offset from start of dnode to
+  u32 magic;				/* 77e4 0aae */
+  u32 first_free;			/* offset from start of dnode to
 					   first free dir entry */
   unsigned root_dnode:1;		/* Is it root dnode? */
   unsigned increment_me:31;		/* some kind of activity counter?
@@ -265,11 +262,11 @@ struct dnode {
   secno up;				/* (root dnode) directory's fnode
 					   (nonroot) parent dnode */
   dnode_secno self;			/* pointer to this dnode */
-  unsigned char dirent[2028];		/* one or more dirents */
+  u8 dirent[2028];			/* one or more dirents */
 };
 
 struct hpfs_dirent {
-  unsigned short length;		/* offset to next dirent */
+  u16 length;			/* offset to next dirent */
   unsigned first: 1;			/* set on phony ^A^A (".") entry */
   unsigned has_acl: 1;
   unsigned down: 1;			/* down pointer present (after name) */
@@ -290,15 +287,15 @@ struct hpfs_dirent {
   unsigned flag15: 1;
   fnode_secno fnode;			/* fnode giving allocation info */
   time32_t write_date;			/* mtime */
-  unsigned file_size;			/* file length, bytes */
+  u32 file_size;			/* file length, bytes */
   time32_t read_date;			/* atime */
   time32_t creation_date;			/* ctime */
-  unsigned ea_size;			/* total EA length, bytes */
+  u32 ea_size;				/* total EA length, bytes */
   unsigned char no_of_acls : 3;		/* number of ACL's */
   unsigned char reserver : 5;
-  unsigned char ix;			/* code page index (of filename), see
+  u8 ix;				/* code page index (of filename), see
 					   struct code_page_data */
-  unsigned char namelen, name[1];	/* file name */
+  u8 namelen, name[1];			/* file name */
   /* dnode_secno down;	  btree down pointer, if present,
      			  follows name on next word boundary, or maybe it
 			  precedes next dirent, which is on a word boundary. */
@@ -318,14 +315,14 @@ struct hpfs_dirent {
 
 struct bplus_leaf_node
 {
-  unsigned file_secno;			/* first file sector in extent */
-  unsigned length;			/* length, sectors */
+  u32 file_secno;			/* first file sector in extent */
+  u32 length;				/* length, sectors */
   secno disk_secno;			/* first corresponding disk sector */
 };
 
 struct bplus_internal_node
 {
-  unsigned file_secno;			/* subtree maps sectors < this  */
+  u32 file_secno;			/* subtree maps sectors < this  */
   anode_secno down;			/* pointer to subtree */
 };
 
@@ -346,10 +343,10 @@ struct bplus_header
   unsigned binary_search: 1;		/* suggest binary search (unused) */
   unsigned internal: 1;			/* 1 -> (internal) tree of anodes
 					   0 -> (leaf) list of extents */
-  unsigned char fill[3];
-  unsigned char n_free_nodes;		/* free nodes in following array */
-  unsigned char n_used_nodes;		/* used nodes in following array */
-  unsigned short first_free;		/* offset from start of header to
+  u8 fill[3];
+  u8 n_free_nodes;			/* free nodes in following array */
+  u8 n_used_nodes;			/* used nodes in following array */
+  u16 first_free;			/* offset from start of header to
 					   first free node in array */
   union {
     struct bplus_internal_node internal[0]; /* (internal) 2-word entries giving
@@ -369,19 +366,18 @@ struct bplus_header
 
 struct fnode
 {
-  unsigned magic;			/* f7e4 0aae */
-  unsigned zero1[2];			/* read history */
-  unsigned char len, name[15];		/* true length, truncated name */
+  u32 magic;				/* f7e4 0aae */
+  u32 zero1[2];				/* read history */
+  u8 len, name[15];			/* true length, truncated name */
   fnode_secno up;			/* pointer to file's directory fnode */
-  /*unsigned zero2[3];*/
   secno acl_size_l;
   secno acl_secno;
-  unsigned short acl_size_s;
-  char acl_anode;
-  char zero2;				/* history bit count */
-  unsigned ea_size_l;			/* length of disk-resident ea's */
+  u16 acl_size_s;
+  u8 acl_anode;
+  u8 zero2;				/* history bit count */
+  u32 ea_size_l;			/* length of disk-resident ea's */
   secno ea_secno;			/* first sector of disk-resident ea's*/
-  unsigned short ea_size_s;		/* length of fnode-resident ea's */
+  u16 ea_size_s;			/* length of fnode-resident ea's */
 
   unsigned flag0: 1;
   unsigned ea_anode: 1;			/* 1 -> ea_secno is an anode */
@@ -407,17 +403,16 @@ struct fnode
     struct bplus_internal_node internal[12];
   } u;
 
-  unsigned file_size;			/* file length, bytes */
-  unsigned n_needea;			/* number of EA's with NEEDEA set */
-  char user_id[16];			/* unused */
-  unsigned short ea_offs;		/* offset from start of fnode
+  u32 file_size;			/* file length, bytes */
+  u32 n_needea;				/* number of EA's with NEEDEA set */
+  u8 user_id[16];			/* unused */
+  u16 ea_offs;				/* offset from start of fnode
 					   to first fnode-resident ea */
-  char dasd_limit_treshhold;
-  char dasd_limit_delta;
-  unsigned dasd_limit;
-  unsigned dasd_usage;
-  /*unsigned zero5[2];*/
-  unsigned char ea[316];		/* zero or more EA's, packed together
+  u8 dasd_limit_treshhold;
+  u8 dasd_limit_delta;
+  u32 dasd_limit;
+  u32 dasd_usage;
+  u8 ea[316];				/* zero or more EA's, packed together
 					   with no alignment padding.
 					   (Do not use this name, get here
 					   via fnode + ea_offs. I think.) */
@@ -430,7 +425,7 @@ struct fnode
 
 struct anode
 {
-  unsigned magic;			/* 37e4 0aae */
+  u32 magic;				/* 37e4 0aae */
   anode_secno self;			/* pointer to this anode */
   secno up;				/* parent anode or fnode */
 
@@ -440,7 +435,7 @@ struct anode
     struct bplus_internal_node internal[60];
   } u;
 
-  unsigned fill[3];			/* unused */
+  u32 fill[3];				/* unused */
 };
 
 
@@ -471,15 +466,15 @@ struct extended_attribute
   unsigned flag5: 1;
   unsigned flag6: 1;
   unsigned needea: 1;			/* required ea */
-  unsigned char namelen;		/* length of name, bytes */
-  unsigned short valuelen;		/* length of value, bytes */
-  unsigned char name[0];
+  u8 namelen;				/* length of name, bytes */
+  u16 valuelen;				/* length of value, bytes */
+  u8 name[0];
   /*
-    unsigned char name[namelen];	ascii attrib name
-    unsigned char nul;			terminating '\0', not counted
-    unsigned char value[valuelen];	value, arbitrary
+    u8 name[namelen];			ascii attrib name
+    u8 nul;				terminating '\0', not counted
+    u8 value[valuelen];			value, arbitrary
       if this.indirect, valuelen is 8 and the value is
-        unsigned length;		real length of value, bytes
+        u32 length;			real length of value, bytes
         secno secno;			sector address where it starts
       if this.anode, the above sector number is the root of an anode tree
         which points to the value.
